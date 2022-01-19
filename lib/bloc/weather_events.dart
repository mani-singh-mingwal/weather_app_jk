class WeatherEvents {}

class FetchWeather extends WeatherEvents {
  String cityName;

  FetchWeather({required this.cityName});
}

class ResetWeather extends WeatherEvents {}
