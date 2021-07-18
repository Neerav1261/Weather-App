import 'package:flutter/material.dart';
import 'package:weather_app/screens/location_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    getLocationData();
    super.initState();
  }
  
  void getLocationData() async {
    LocationGet location = LocationGet();
    await location.getCurrentLocation();
    var weatherDataCurrent = await WeatherModel().getLocationWeatherCurrent(location.latitude, location.longitude);
    var weatherDataAll = await WeatherModel().getLocationWeatherAll(location.latitude, location.longitude);
    var weatherDataAQI = await WeatherModel().getLocationWeatherAQI(location.latitude, location.longitude);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return LocationScreen(weatherDataCurrent, weatherDataAll, weatherDataAQI);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitCircle(
          color: Colors.grey[850],
          size: 80,
        ),
      ),
    );
  }
}