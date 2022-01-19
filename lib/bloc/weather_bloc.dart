import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_jk/bloc/weather_events.dart';
import 'package:weather_app_jk/bloc/weather_state.dart';
import 'package:weather_app_jk/models/weather_model.dart';
import 'package:weather_app_jk/repository/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvents, WeatherState> {
  WeatherRepository weatherRepository;

  WeatherBloc(WeatherState initialState, {required this.weatherRepository})
      : super(WeatherIsNotSearched()) {
    on<FetchWeather>((event, emit) async {
      Main? weatherModel;

      emit(WeatherIsLoading());
      if (event is FetchWeather) {
        try {
          weatherModel =
              await weatherRepository.getWeatherRequest(event.cityName);
          emit(WeatherIsLoaded(weatherModel: weatherModel));
        } catch (e) {
          debugPrint("$e");
          emit(WeatherIsNotLoaded());
        }
      }
    });

    on<ResetWeather>((event, emit) => emit(WeatherIsNotSearched()));
  }
}
