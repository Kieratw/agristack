import 'package:agristack/app/controllers/map_controller.dart';
import 'package:agristack/app/services/location_permissions.dart';
import 'package:agristack/domain/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends ConsumerWidget {
  final int? fieldId;

  const MapPage({super.key, this.fieldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mapControllerProvider(fieldId));

    return Scaffold(
      appBar: AppBar(
        title: Text(fieldId != null ? 'Mapa pola' : 'Mapa diagnoz'),
      ),
      body: state.when(
        data: (entries) => _MapBody(entries: entries),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Błąd: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            ref.read(mapControllerProvider(fieldId).notifier).refresh(),
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}

class _MapBody extends StatefulWidget {
  final List<DiagnosisEntryEntity> entries;
  const _MapBody({required this.entries});

  @override
  State<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends State<_MapBody> {
  GoogleMapController? _controller;
  late Future<LatLng> _initialTargetFuture;

  @override
  void initState() {
    super.initState();
    // Poproś o uprawnienia przy pierwszym wejściu
    LocationPermissions.ensureLocationGranted();
    _initialTargetFuture = _computeInitialTarget();
  }

  Future<LatLng> _computeInitialTarget() async {
    // 1. Spróbuj znaleźć diagnozę z lokalizacją
    final withLocation = widget.entries
        .where((e) => e.lat != null && e.lng != null)
        .toList();

    if (withLocation.isNotEmpty) {
      final first = withLocation.first;
      return LatLng(first.lat!, first.lng!);
    }

    // 2. Brak diagnoz -> spróbuj pozycji urządzenia
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      // 3. Fallback: środek Polski
      return const LatLng(52.0, 19.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Markery tylko dla diagnoz z GPS
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
              context.push('/app/diagnosis/details', extra: e);
            },
          ),
    };

    return FutureBuilder<LatLng>(
      future: _initialTargetFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final camera = CameraPosition(
          target: snapshot.data!,
          zoom: markers.isNotEmpty ? 12 : 8,
        );

        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.satellite, // TU masz satelitę
              initialCameraPosition: camera,
              markers: markers,
              onMapCreated: (c) => _controller = c,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            if (markers.isEmpty)
              const Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Brak zapisanych diagnoz z lokalizacją.\n'
                      'Pokazuję tylko Twoją pozycję (jeśli zgodziłeś się na lokalizację).',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
