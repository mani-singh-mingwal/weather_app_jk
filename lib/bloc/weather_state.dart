import 'package:equatable/equatable.dart';
import 'package:weather_app_jk/models/weather_model.dart';

class WeatherState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherIsNotSearched extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final Main? weatherModel;

  WeatherIsLoaded({required this.weatherModel});

  @override
  // TODO: implement props
  List<Object?> get props => [weatherModel];
}

class WeatherIsNotLoaded extends WeatherState {}
