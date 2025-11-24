import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeometryUtils {
  /// Oblicza powierzchnię wielokąta w hektarach (ha).
  /// Używa uproszczonego modelu sferycznego Ziemi.
  static double calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    const double earthRadius = 6371000; // metry

    double area = 0.0;
    if (points.length > 2) {
      for (var i = 0; i < points.length; i++) {
        var p1 = points[i];
        var p2 = points[(i + 1) % points.length];
        area +=
            _toRadians(p2.longitude - p1.longitude) *
            (2 + sin(_toRadians(p1.latitude)) + sin(_toRadians(p2.latitude)));
      }
      area = area * earthRadius * earthRadius / 2.0;
    }

    // Wynik jest w m^2, konwersja na hektary (1 ha = 10,000 m^2)
    return (area.abs() / 10000.0);
  }

  static LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    for (final p in points) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  static double _toRadians(double degree) {
    return degree * pi / 180.0;
  }

  static LatLng calculatePolygonCentroid(List<LatLng> points) {
    if (points.isEmpty) return const LatLng(0, 0);
    if (points.length == 1) return points.first;

    double area = 0.0;
    double cx = 0.0;
    double cy = 0.0;

    for (int i = 0; i < points.length; i++) {
      final p1 = points[i];
      final p2 = points[(i + 1) % points.length];

      final crossProduct =
          p1.latitude * p2.longitude - p2.latitude * p1.longitude;
      area += crossProduct;
      cx += (p1.latitude + p2.latitude) * crossProduct;
      cy += (p1.longitude + p2.longitude) * crossProduct;
    }

    if (area == 0) return points.first; // Fallback for degenerate polygons

    area *= 0.5;
    cx /= (6 * area);
    cy /= (6 * area);

    return LatLng(cx, cy);
  }
}
