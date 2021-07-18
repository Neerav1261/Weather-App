import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_app/screens/city_screen.dart';
import 'package:weather_app/services/location.dart';
import 'package:weather_app/services/weather.dart';
import 'package:weather_app/utilities/progress_dialog.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen(this.locationWeatherCurrent, this.locationWeatherAll, this.locationWeatherAQI);
  final locationWeatherCurrent;
  final locationWeatherAll;
  final locationWeatherAQI;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int currentTemp = 0, feelsLike = 0, maxTemp = 0, minTemp = 0, sunrise = 0, sunset = 0, uvi = 0, windDegree = 0;
  int currentTimeHour = 0, currentTimeMin = 0, riseMin = 0, setMin = 0, riseHr = 0, setHr = 0;
  var aqi;
  int sunriseHour = 0,  sunsetHour = 0;
  String condition = '', city = '', sunriseMin = '', sunsetMin = '', windDir = '', windSpeed = '';
  Color currentColor = Colors.blueAccent;

  @override
  void initState() {
    updateUI(widget.locationWeatherCurrent, widget.locationWeatherAll, widget.locationWeatherAQI);
    super.initState();
  }

  void updateUI(dynamic weatherDataCurrent, dynamic weatherDataAll, dynamic weatherDataAQI) {
    setState(() {
      currentTemp = weatherDataCurrent['main']['temp'].toInt();
      feelsLike = weatherDataCurrent['main']['feels_like'].toInt();
      minTemp = weatherDataAll['daily'][0]['temp']['min'].toInt();
      maxTemp = weatherDataAll['daily'][0]['temp']['max'].toInt();
      sunrise = weatherDataCurrent['sys']['sunrise'];
      sunset = weatherDataCurrent['sys']['sunset'];
      condition = weatherDataCurrent['weather'][0]['main'];
      uvi = weatherDataAll['current']['uvi'].toInt();
      windSpeed = weatherDataAll['current']['wind_speed'].toStringAsFixed(2);
      windDegree = weatherDataAll['current']['wind_deg'].toInt();
      city = weatherDataCurrent['name'];

      aqi = weatherDataAQI['list'][0]['components']['pm2_5']>weatherDataAQI['list'][0]['components']['pm10']
          ? weatherDataAQI['list'][0]['components']['pm2_5'] :
      weatherDataAQI['list'][0]['components']['pm10'];
      sunriseHour = WeatherModel().getHour(sunrise);
      sunriseMin = WeatherModel().getMin(sunrise);
      sunsetHour = WeatherModel().getHour(sunset);
      sunsetMin = WeatherModel().getMin(sunset);
      windDir = WeatherModel().getDir(windDegree);
      print(city);

      currentTimeHour = DateTime.now().hour.toInt();
      currentTimeMin = DateTime.now().minute.toInt();
      riseHr = WeatherModel().getHr(sunrise);
      setHr = WeatherModel().getHr(sunset);
      riseMin = WeatherModel().getMinutes(sunrise);
      setMin = WeatherModel().getMinutes(sunset);
      if(currentTimeHour > riseHr && currentTimeHour < setHr){
        currentColor = Colors.blueAccent;
      } else {
        currentColor = Colors.grey[850];
        //currentColor = Colors.blueAccent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        backgroundColor: currentColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () async {
            var typedName = await Navigator.push(context, CupertinoPageRoute(builder: (context)=>CityScreen(currentColor: currentColor)));
            print(typedName);
            if(typedName != null) {
              ProgressDialog progressDialog = getProgress(context);
              progressDialog.show();
              var weatherDataCity = await WeatherModel().getLocationWeatherCity(typedName);
              var weatherDataAll = await WeatherModel().getLocationWeatherAll(weatherDataCity['coord']['lat'], weatherDataCity['coord']['lon']);
              var weatherDataAQI = await WeatherModel().getLocationWeatherAQI(weatherDataCity['coord']['lat'], weatherDataCity['coord']['lon']);

              progressDialog.dismiss();
              updateUI(weatherDataCity, weatherDataAll, weatherDataAQI);
            }
          },
          child: Icon(
            Icons.add_location_alt_rounded,
          ),
        ),
        title: Text(city),
        centerTitle: true,
        actions: [
          popUP()
        ]
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 80),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text('$currentTemp', style: TextStyle(fontSize: 120)),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18),
                              child: Text('°C', style: TextStyle(fontSize: 25)),
                            )
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text('$condition', style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 20)),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.13), borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(11, 5, 11, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.masks_rounded,
                              size: 18,
                            ),
                            Text(' AQI ${aqi.toInt()}', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Table(
                //border:TableBorder.all(width: 1.5,color: Colors.red),
                children: [
                  TableRow(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Spacer(),
                          Text('$maxTemp', style: TextStyle(fontSize: 70)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('°C', style: TextStyle(fontSize: 18)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Spacer(),
                          Text('$minTemp', style: TextStyle(fontSize: 70)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text('°C', style: TextStyle(fontSize: 18)),
                          )
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Text('Maximum', style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center),
                      Text('Minimum', style: TextStyle(color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center)
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Table(
                        border: TableBorder(
                          verticalInside: BorderSide(width: 1, color: Colors.white.withOpacity(0.5)),
                        ),
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text('Sunrise', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('Sunset', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                            )
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 10, 10),
                              child: Text(
                                  '$sunriseHour:$sunriseMin',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 5, 10),
                              child: Text(
                                  '$sunsetHour:$sunsetMin',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            Divider(thickness: 1, color: Colors.white.withOpacity(0.5)),
                            Divider(thickness: 1, color: Colors.white.withOpacity(0.5))
                          ]
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              child: Text('UV Index', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text('Wind Speed', style: TextStyle(color: Colors.white.withOpacity(0.6))),
                            )
                          ],
                        ),
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 40, 10, 0),
                                child: Text(
                                    '$uvi',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 40, 5, 0),
                                child: Text(
                                    '$windSpeed km/h  $windDir',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15)
                                ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('Data provided by  ', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10)),
                    Image.asset('images/logo1.png', scale: 11, ),
                    Image.asset('images/logo2.png', scale: 8, color: Colors.white.withOpacity(0.5))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget popUP() {
    return PopupMenuButton(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      offset: Offset(0, 15),
      padding: EdgeInsets.only(right: 5),
      color: Colors.white,
      onSelected: (value) async {
        if(value == 1) {
          ProgressDialog progressDialog = getProgress(context);
          progressDialog.show();
          LocationGet location = LocationGet();
          await location.getCurrentLocation();
          var weatherDataCurrent = await WeatherModel().getLocationWeatherCurrent(location.latitude, location.longitude);
          var weatherDataAll = await WeatherModel().getLocationWeatherAll(location.latitude, location.longitude);
          var weatherDataAQI = await WeatherModel().getLocationWeatherAQI(location.latitude, location.longitude);

          progressDialog.dismiss();

          updateUI(weatherDataCurrent, weatherDataAll, weatherDataAQI);
        }
        if(value == 2) {
          print(value);
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
            child: Text('Refresh', style: TextStyle(color: Colors.grey[850]))
        ),
        PopupMenuItem(
          value: 2,
            child: Text('About Us', style: TextStyle(color: Colors.grey[850]))
        ),
        PopupMenuItem(
          value: 3,
            child: Text('Settings', style: TextStyle(color: Colors.grey[850]))
        )
      ],
    );
  }
}

  ProgressDialog getProgress(context) {
    ProgressDialog progressDialog = ProgressDialog(
        context,
        blur: 3,
        dismissable: false,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 400)
    );
    return progressDialog;
  }