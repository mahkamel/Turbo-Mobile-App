import 'package:geolocator/geolocator.dart';

import '../../location_services.dart';

class AuthRepository {
  String? currentAddress;
  Position? currentPosition;

  Future<void> getCurrentUserLocation() async {
    await LocationServices.getCurrentPosition().then(
      (value) async {
        if (value != null) {
          currentPosition = value;
          currentAddress = await LocationServices.getAddressFromLatLng(
            currentPosition!,
          );
        }
      },
    );
  }
}
