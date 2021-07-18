import 'package:geolocator/geolocator.dart';

class LocationGet {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try{

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print('${position.latitude} & ${position.longitude}');
      latitude = position.latitude;
      longitude = position.longitude;
    }
    catch (e) {
      print(e);
    }
  }
}