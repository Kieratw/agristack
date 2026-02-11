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
  int? _selectedYear;

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
    // Reset edit state for new field
    _polygonPoints = [];
    _currentArea = 0.0;
    _isEditMode = false;

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

            // --- Year Filter (Only for Global Map & Not Picker & Not Edit) ---
            if (!widget.isPicker && widget.fieldId == null && !_isEditMode)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: SafeArea(
                  child: Center(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final yearsAsync = ref.watch(availableMapYearsProvider);
                        final years = yearsAsync.valueOrNull ?? [];

                        if (years.isEmpty) return const SizedBox.shrink();

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedYear,
                              hint: const Text('Wszystkie lata'),
                              icon: const Icon(Icons.calendar_month),
                              items: [
                                const DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('Wszystkie lata'),
                                ),
                                ...years.map(
                                  (y) => DropdownMenuItem<int>(
                                    value: y,
                                    child: Text(y.toString()),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                setState(() {
                                  _selectedYear = val;
                                });
                                ref
                                    .read(
                                      mapControllerProvider(
                                        widget.fieldId,
                                      ).notifier,
                                    )
                                    .setYear(val);

                                // Refresh manually just in case, though stream should handle it
                                // ref.invalidate(mapControllerProvider(widget.fieldId));
                              },
                            ),
                          ),
                        );
                      },
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
      if (field.polygon == null || field.polygon!.isEmpty) return;
      final points = field.polygon!.map((p) => LatLng(p.lat, p.lng)).toList();

      // Calculate field extent to determine desired width
      final bounds = GeometryUtils.calculateBounds(points);
      final widthMeters = Geolocator.distanceBetween(
        bounds.southwest.latitude,
        bounds.southwest.longitude,
        bounds.southwest.latitude,
        bounds.northeast.longitude,
      );

      // Estimate pixel width at zoom level ~15/16
      // At zoom 15, 1px ~= 4.77m (at equator, less at higher lat).
      // At lat 52, cos(52) ~= 0.6. So 1px ~= 4.77 * 0.6 ~= 2.9m.
      // Let's assume a target text width relative to field width.
      // We want text to cover roughly 60-80% of width?
      // Or just choose font size based on physical size.

      // Simplified approach: A field 100m wide -> Text should be maybe 60m wide?
      // Just pass the desired width in meters to helper?
      // Marker bitmap isn't zoomed by Google Maps automatically for `Marker`. It stays constant pixel size.
      // This is a trade-off. We can't easily resize marker on zoom change without creating new bitmaps.
      // USER REQUEST: fit inside boundaries.
      // We'll generate a bitmap that is "reasonable" size.
      // If the field is huge (1km), we want a bigger label. If small (50m), smaller label.

      // Let's use a scale factor.
      // Small field < 1ha (<100m side) -> fontSize 20
      // Medium field -> fontSize 30
      // Large field -> fontSize 40...

      double fontSize = 24.0;
      if (widthMeters < 100) {
        fontSize = 20.0;
      } else if (widthMeters < 300) {
        fontSize = 30.0;
      } else if (widthMeters < 600) {
        fontSize = 45.0;
      } else {
        fontSize = 60.0;
      }

      final icon = await _createLabelMarkerBitmap(field.name, fontSize);
      if (mounted) {
        setState(() {
          _markerIcons[field.id] = icon;
        });
      }
    } catch (e) {
      debugPrint('Error generating marker icon for field ${field.id}: $e');
    }
  }

  Future<BitmapDescriptor> _createLabelMarkerBitmap(
    String text,
    double fontSize,
  ) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    // Padding for the glow/outline
    const padding = 20.0;

    // 1. Setup Painters
    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    );

    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final width = textPainter.width + padding * 2;
    final height = textPainter.height + padding * 2;

    // 2. Draw Outline (Halo)
    // We draw the text with a thick stroke in black
    final outlineStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..color = Colors.black,
    );

    final outlinePainter = TextPainter(
      text: TextSpan(text: text, style: outlineStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    outlinePainter.layout();
    outlinePainter.paint(
      canvas,
      Offset(
        (width - outlinePainter.width) / 2,
        (height - outlinePainter.height) / 2,
      ),
    );

    // 3. Draw Fill (White)
    textPainter.paint(
      canvas,
      Offset(
        (width - textPainter.width) / 2,
        (height - textPainter.height) / 2,
      ),
    );

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
