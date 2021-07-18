import 'package:weather_app/services/networking.dart';
import 'package:intl/intl.dart';
const apikey = 'Your API Key';
const url_owm = 'https://api.openweathermap.org/data/2.5/';
class WeatherModel {

  Future<dynamic> getLocationWeatherCurrent(double latitude, double longitude) async {
    Network weather = Network('${url_owm}weather?lat=$latitude&lon=$longitude&appid=$apikey&units=metric');
    var weatherData = await weather.getData();
    print('current');
    return weatherData;
  }

  Future<dynamic> getLocationWeatherAll(double latitude, double longitude) async {
    Network weather = Network('${url_owm}onecall?lat=$latitude&lon=$longitude&units=metric&exclude=minutely,hourly&appid=$apikey');
    var weatherData = await weather.getData();
    print('all');
    return weatherData;
  }
  Future<dynamic> getLocationWeatherAQI(double latitude, double longitude) async {
    Network weather = Network('${url_owm}air_pollution?lat=$latitude&lon=$longitude&appid=$apikey');
    var weatherData = await weather.getData();
    print('aqi');
    return weatherData;
  }
  Future<dynamic> getLocationWeatherCity(String city) async {
    Network weather = Network('${url_owm}weather?q=$city&units=metric&appid=$apikey');
    var weatherData = await weather.getData();
    print('city');
    return weatherData;
  }

  int getHour(int unix) {
    var formattedHour = int.parse(DateFormat.H().format(DateTime.fromMillisecondsSinceEpoch(unix*1000)));
    if(formattedHour > 12)
      return formattedHour - 12;
    return formattedHour;
  }

  String getMin(int unix) {
    String formattedMin = DateFormat.m().format(DateTime.fromMillisecondsSinceEpoch(unix*1000));
    if(int.parse(DateFormat.s().format(DateTime.fromMillisecondsSinceEpoch(unix*1000))) >= 30) {
      formattedMin = '${int.parse(formattedMin)+1}';
      if(int.parse(DateFormat.H().format(DateTime.fromMillisecondsSinceEpoch(unix*1000))) > 12) {
        if(int.parse(formattedMin) >= 0 && int.parse(formattedMin) <=9)
          return '0$formattedMin PM';
        return '$formattedMin PM';
      }
      if(int.parse(formattedMin) >= 0 && int.parse(formattedMin) <=9)
        return '0$formattedMin AM';
      return '$formattedMin AM';
    } else {
      if(int.parse(formattedMin) >= 0 && int.parse(formattedMin) <=9)
        formattedMin = '0$formattedMin';
      if(int.parse(DateFormat.H().format(DateTime.fromMillisecondsSinceEpoch(unix*1000))) > 12)
        return '$formattedMin PM';
      return '$formattedMin AM';
    }
  }

  int getMinutes(int unix){
    String formattedMin = DateFormat.m().format(DateTime.fromMillisecondsSinceEpoch(unix*1000));
    return int.parse(formattedMin);
  }

  int getHr(int unix){
    int formattedHour = int.parse(DateFormat.H().format(DateTime.fromMillisecondsSinceEpoch(unix*1000)));
    return formattedHour;
  }

  String getDir(int deg) {
    if (deg >=0 && deg >= 349) {
      return 'N';
    } else if (deg >= 12 && deg <= 33) {
      return 'NNE';
    } else if (deg >= 34 && deg <= 56) {
      return 'NE';
    } else if (deg >= 57 && deg <= 78) {
      return 'ENE';
    } else if (deg >= 79 && deg <= 101) {
      return 'E';
    } else if (deg >= 102 && deg <= 123) {
      return 'ESE';
    } else if (deg >= 124 && deg <= 146) {
      return 'SE';
    } else if (deg >= 147 && deg <= 168) {
      return 'SSE';
    } else if (deg >= 169 && deg <= 191) {
      return 'S';
    } else if (deg >= 192 && deg <= 213) {
      return 'SSW';
    } else if (deg >= 214 && deg <= 236) {
      return 'SW';
    } else if (deg >= 237 && deg <= 258) {
      return 'WSW';
    } else if (deg >= 259 && deg <= 281) {
      return 'W';
    } else if (deg >= 282 && deg <= 303) {
      return 'WNW';
    } else if (deg >= 304 && deg <= 326) {
      return 'NW';
    } else {
      return 'NNW‍';
    }
  }
  //
  // String getAQIValue(var aqiData) {
  //   if (aqiData >=0 && aqiData <= 30) {
  //     return 'Good';
  //   } else if (aqiData >=31 && aqiData <= 60) {
  //     return 'Satisfactory';
  //   } else if (aqiData >=61 && aqiData <= 90) {
  //     return 'Moderately Polluted';
  //   } else if (aqiData >=91 && aqiData <= 120) {
  //     return 'Poor';
  //   } else if (aqiData >=121 && aqiData <= 250) {
  //     return 'Very Poor';
  //   }  else if (aqiData >=251) {
  //     return 'Severe';
  //   }
  // }
}