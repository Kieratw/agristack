import 'package:geolocator/geolocator.dart';

class LocationPermissions {
  /// Sprawdza i ewentualnie prosi usera o zgodę na lokalizację.
  static Future<bool> ensureLocationGranted() async {
    // GPS w ogóle włączony?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Tu możesz potem dodać info typu "włącz GPS"
      return false;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Użytkownik kliknął "nie pytaj ponownie"
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
}