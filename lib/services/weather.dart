import 'package:sky/services/location.dart';
import 'package:sky/services/networking.dart';

const apiKey = 'f7da0f576749873b2023de9f433780b6';
const openWetherMapURL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWether(String cityName) async{
    NetWorkHelper netWorkHelper = NetWorkHelper(
        '$openWetherMapURL?q=$cityName&appid=$apiKey&units=metric');
    var wetherData = await netWorkHelper.getData();
    return wetherData;
  }

  Future<dynamic> getLocationWether() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetWorkHelper netWorkHelper = NetWorkHelper(
        '$openWetherMapURL?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var wetherData = await netWorkHelper.getData();
    return wetherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
