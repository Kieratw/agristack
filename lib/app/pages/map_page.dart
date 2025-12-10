import 'package:agristack/app/controllers/fields_controller.dart';
import 'package:agristack/app/controllers/map_controller.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/app/services/location_permissions.dart';
import 'package:agristack/app/utils/geometry_utils.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MapPage extends ConsumerWidget {
  final int? fieldId;
  final bool isPicker;

  const MapPage({super.key, this.fieldId, this.isPicker = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapControllerProvider(fieldId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isPicker
              ? 'Wybierz lokalizację'
              : (fieldId != null ? 'Mapa pola' : 'Mapa diagnoz'),
        ),
      ),
      body: state.when(
        data: (entries) =>
            _MapBody(entries: entries, fieldId: fieldId, isPicker: isPicker),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: $e')),
      ),
    );
  }
}

class _MapBody extends ConsumerStatefulWidget {
  final List<DiagnosisEntryEntity> entries;
  final int? fieldId;
  final bool isPicker;

  const _MapBody({required this.entries, this.fieldId, this.isPicker = false});

  @override
  ConsumerState<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends ConsumerState<_MapBody> {
  GoogleMapController? _controller;
  late Future<LatLngBounds?> _initialBoundsFuture;

  // Edit mode state
  bool _isEditMode = false;
  List<LatLng> _polygonPoints = [];
  double _currentArea = 0.0;
  final Map<int, BitmapDescriptor> _markerIcons = {};

  // Picker mode state
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    LocationPermissions.ensureLocationGranted();
    _initialBoundsFuture = _computeInitialBounds();
    if (widget.isPicker) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dotknij mapy, aby wybrać lokalizację'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  Future<LatLngBounds?> _computeInitialBounds() async {
    // 1. If specific field selected, focus on it
    if (widget.fieldId != null) {
      try {
        final repo = await ref.read(fieldsRepoProvider.future);
        final res = await repo.get(widget.fieldId!);
        if (res.isOk && res.data != null) {
          final field = res.data!;

          if (field.polygon != null && field.polygon!.isNotEmpty) {
            final points = field.polygon!
                .map((p) => LatLng(p.lat, p.lng))
                .toList();
            _polygonPoints = points; // Initialize edit points
            _currentArea =
                field.area ?? GeometryUtils.calculatePolygonArea(points);
            return GeometryUtils.calculateBounds(points);
          }

          if (field.centerLat != null && field.centerLng != null) {
            final p = LatLng(field.centerLat!, field.centerLng!);
            return LatLngBounds(southwest: p, northeast: p);
          }
        }
      } catch (e) {
        debugPrint('Error loading field: $e');
      }
    }

    // 2. If no field selected (or field has no location), try to fit all fields
    try {
      final repo = await ref.read(fieldsRepoProvider.future);
      final res = await repo.getAll();
      if (res.isOk && res.data != null && res.data!.isNotEmpty) {
        final allPoints = <LatLng>[];
        for (final f in res.data!) {
          if (f.polygon != null) {
            allPoints.addAll(f.polygon!.map((p) => LatLng(p.lat, p.lng)));
          } else if (f.centerLat != null && f.centerLng != null) {
            allPoints.add(LatLng(f.centerLat!, f.centerLng!));
          }
        }
        if (allPoints.isNotEmpty) {
          return GeometryUtils.calculateBounds(allPoints);
        }
      }
    } catch (e) {
      debugPrint('Error loading all fields: $e');
    }

    // 3. User location
    try {
      final pos = await Geolocator.getCurrentPosition();
      final p = LatLng(pos.latitude, pos.longitude);

      // If picker mode and no location picked yet, set it to user location initially
      if (widget.isPicker && _pickedLocation == null) {
        // We can't setState here easily as it's async and called from initState
        // But we can set it after frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _pickedLocation = p;
            });
          }
        });
      }

      return LatLngBounds(southwest: p, northeast: p);
    } catch (_) {
      return null; // Default to Poland center in build
    }
  }

  void _updateArea() {
    setState(() {
      _currentArea = GeometryUtils.calculatePolygonArea(_polygonPoints);
    });
  }

  void _onMapTap(LatLng point) {
    if (widget.isPicker) {
      setState(() {
        _pickedLocation = point;
      });
      return;
    }

    if (!_isEditMode) return;

    setState(() {
      _polygonPoints.add(point);
      _updateArea();
    });
  }

  void _undo() {
    if (_polygonPoints.isNotEmpty) {
      setState(() {
        _polygonPoints.removeLast();
        _updateArea();
      });
    }
  }

  void _clear() {
    setState(() {
      _polygonPoints.clear();
      _updateArea();
    });
  }

  Future<void> _save(int fieldId) async {
    if (_polygonPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poligon musi mieć co najmniej 3 punkty')),
      );
      return;
    }

    try {
      await ref
          .read(fieldsControllerProvider.notifier)
          .updateFieldPolygon(fieldId, _polygonPoints);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Zapisano granice pola')));

        // Refresh map fields to show the new polygon
        ref.invalidate(mapFieldsProvider);

        setState(() {
          _isEditMode = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd zapisu: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      for (final e in widget.entries)
        if (e.lat != null && e.lng != null)
          Marker(
            markerId: MarkerId(e.id.toString()),
            position: LatLng(e.lat!, e.lng!),
            infoWindow: InfoWindow(
              title: e.displayLabelPl,
              snippet:
                  '${e.canonicalDiseaseId} • ${(e.confidence * 100).toStringAsFixed(1)}%',
            ),
            onTap: () {
              if (!widget.isPicker && !_isEditMode) {
                context.push('/app/diagnosis/details', extra: e);
              }
            },
          ),
    };

    if (_isEditMode) {
      for (var i = 0; i < _polygonPoints.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId('poly_$i'),
            position: _polygonPoints[i],
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            draggable: true,
            onDragEnd: (newPos) {
              setState(() {
                _polygonPoints[i] = newPos;
                _updateArea();
              });
            },
          ),
        );
      }
    }

    if (widget.isPicker && _pickedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('picked_loc'),
          position: _pickedLocation!,
          draggable: true,
          onDragEnd: (newPos) {
            setState(() {
              _pickedLocation = newPos;
            });
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    final allFieldsAsync = ref.watch(mapFieldsProvider);
    final allFields = allFieldsAsync.valueOrNull ?? [];

    final polygons = <Polygon>{};

    // 1. Draw all fields from DB
    for (final f in allFields) {
      if (f.polygon != null && f.polygon!.isNotEmpty) {
        final isSelected = f.id == widget.fieldId;
        // If we are in edit mode for this field, skip drawing it here (drawn by _polygonPoints)
        if (_isEditMode && isSelected) continue;

        polygons.add(
          Polygon(
            polygonId: PolygonId('field_${f.id}'),
            points: f.polygon!.map((p) => LatLng(p.lat, p.lng)).toList(),
            fillColor: isSelected
                ? Colors.green.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.3),
            strokeColor: isSelected ? Colors.green : Colors.grey,
            strokeWidth: 2,
            consumeTapEvents: !widget.isPicker,
            onTap: () {
              // Optional: tap to select field?
            },
          ),
        );
      }
    }

    // 2. Draw current editing polygon
    if (_isEditMode && _polygonPoints.isNotEmpty) {
      polygons.add(
        Polygon(
          polygonId: const PolygonId('field_boundary_edit'),
          points: _polygonPoints,
          fillColor: Colors.green.withValues(alpha: 0.3),
          strokeColor: Colors.green,
          strokeWidth: 2,
        ),
      );
    }

    // 3. Add field name markers
    for (final f in allFields) {
      if (f.polygon != null && f.polygon!.isNotEmpty) {
        final points = f.polygon!.map((p) => LatLng(p.lat, p.lng)).toList();
        final center = GeometryUtils.calculatePolygonCentroid(points);

        BitmapDescriptor icon = BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        );
        // Use cached icon if available, otherwise generate it
        if (_markerIcons.containsKey(f.id)) {
          icon = _markerIcons[f.id]!;
        } else {
          _generateMarkerIcon(f);
        }

        markers.add(
          Marker(
            markerId: MarkerId('label_${f.id}'),
            position: center,
            icon: icon,
            // Anchor to center
            anchor: const Offset(0.5, 0.5),
            onTap: () {
              // Optional: Navigate to field details on label tap
              if (!widget.isPicker && !_isEditMode) {
                // We don't have a direct route to field details from here easily without context,
                // but we can just ignore or show info window.
              }
            },
          ),
        );
      }
    }

    return FutureBuilder<LatLngBounds?>(
      // Changed to Bounds
      future: _initialBoundsFuture, // We need to compute bounds now
      builder: (context, snapshot) {
        // ...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bounds = snapshot.data;
        final initialTarget = bounds != null
            ? LatLng(
                (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
              )
            : const LatLng(52.0, 19.0);

        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: initialTarget,
                zoom: 15, // Default zoom, will be updated by bounds
              ),
              markers: markers,
              polygons: polygons,
              style: '''
                    [
                      {
                        "featureType": "poi",
                        "stylers": [
                          { "visibility": "off" }
                        ]
                      }
                    ]
                  ''',
              onMapCreated: (c) async {
                _controller = c;

                if (bounds != null) {
                  // Add some padding
                  Future.delayed(const Duration(milliseconds: 300), () {
                    c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
                  });
                }
              },
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

            if (_isEditMode)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Text(
                          'Powierzchnia: ${_currentArea.toStringAsFixed(2)} ha',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.undo, color: Colors.white),
                          onPressed: _undo,
                          tooltip: 'Cofnij',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          ),
                          onPressed: _clear,
                          tooltip: 'Wyczyść',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 100,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.isPicker) ...[
                    FloatingActionButton.extended(
                      heroTag: 'pick_loc',
                      onPressed: _pickedLocation == null
                          ? null
                          : () {
                              context.pop(_pickedLocation);
                            },
                      label: const Text('Wybierz'),
                      icon: const Icon(Icons.check),
                      backgroundColor: _pickedLocation == null
                          ? Colors.grey
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (!widget.isPicker && widget.fieldId != null) ...[
                    if (_isEditMode)
                      FloatingActionButton.extended(
                        heroTag: 'save_poly',
                        onPressed: () => _save(widget.fieldId!),
                        label: const Text('Zapisz'),
                        icon: const Icon(Icons.check),
                        backgroundColor: Colors.green,
                      )
                    else
                      FloatingActionButton(
                        heroTag: 'edit_poly',
                        onPressed: () {
                          setState(() {
                            _isEditMode = true;
                          });
                        },
                        child: const Icon(Icons.edit_location_alt),
                      ),
                    const SizedBox(height: 16),
                  ],

                  FloatingActionButton(
                    heroTag: 'my_loc',
                    onPressed: () async {
                      final pos = await Geolocator.getCurrentPosition();
                      _controller?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(pos.latitude, pos.longitude),
                        ),
                      );
                    },
                    child: const Icon(Icons.my_location),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateMarkerIcon(FieldEntity field) async {
    try {
      final icon = await _createLabelMarkerBitmap(field.name);
      if (mounted) {
        setState(() {
          _markerIcons[field.id] = icon;
        });
      }
    } catch (e) {
      debugPrint('Error generating marker icon for field ${field.id}: $e');
    }
  }

  Future<BitmapDescriptor> _createLabelMarkerBitmap(String text) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    const fontSize = 26.0;
    const paddingHorizontal = 12.0;
    const paddingVertical = 6.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

    textPainter.layout();

    final width = textPainter.width + paddingHorizontal * 2;
    final height = textPainter.height + paddingVertical * 2;

    // Draw Background
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(16),
    );

    canvas.drawRRect(rect, paint);

    // Draw Border (Optional, but looks nice)
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rect, borderPaint);

    // Draw Text
    textPainter.paint(canvas, Offset(paddingHorizontal, paddingVertical));

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
