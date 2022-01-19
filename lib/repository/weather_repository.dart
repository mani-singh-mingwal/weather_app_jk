import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_jk/models/weather_model.dart';

class WeatherRepository {
  Future<Main?> getWeatherRequest(String cityName) async {
    Main? weatherModel;
    http.Response response;
    String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=3f1aa301905a51ef7b7f85499b2a3c93";
    response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception();
    } else if (response.statusCode == 200) {
      final jsonDecoded = json.decode(response.body);
      final jsonWeather = jsonDecoded["main"];
      weatherModel = Main.fromJson(jsonWeather);
    }
    return weatherModel;
  }
}
