import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_jk/bloc/internet_cubit.dart';
import 'package:weather_app_jk/bloc/internet_state.dart';
import 'package:weather_app_jk/bloc/weather_bloc.dart';
import 'package:weather_app_jk/bloc/weather_events.dart';
import 'package:weather_app_jk/bloc/weather_state.dart';
import 'package:weather_app_jk/models/weather_model.dart';
import 'package:weather_app_jk/repository/weather_repository.dart';
import 'package:weather_app_jk/utitlity/app_bloc_observer.dart';
import 'package:weather_app_jk/widgets.dart';

import 'my_behavior.dart';

void main() {
  BlocOverrides.runZoned(
      () => runApp(MyApp(
            connectivity: Connectivity(),
            weatherRepository: WeatherRepository(),
          )),
      blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key, required this.connectivity, required this.weatherRepository})
      : super(key: key);
  final WeatherRepository weatherRepository;
  final Connectivity connectivity;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<InternetCubit>(
              create: (context) =>
                  InternetCubit(InternetLoading(), connectivity: connectivity)),
          BlocProvider<WeatherBloc>(
              create: (context) => WeatherBloc(WeatherIsNotSearched(),
                  weatherRepository: weatherRepository))
        ],
        child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.blue),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.grey[900],
            body: SearchPage(),
          ),
        ));
  }
}

class SearchPage extends StatelessWidget {
  final _searchController = TextEditingController();

  SearchPage({Key? key}) : super(key: key);

  final snackBar = SnackBar(
      content: Text(
    "No connection",
    textAlign: TextAlign.center,
  ));

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, state) {
        if (state is InternetConnected) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          debugPrint("connected");
        } else if (state is InternetDisconnected) {
          _showSnackBar(context, "No connection");
          debugPrint("No connection");
        }
      },
      child: Center(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: SizedBox(
                  width: 180,
                  height: 180,
                  child: Image.asset("images/world_image.png"),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
                final internetState = context.watch<InternetCubit>().state;
                if (state is WeatherIsNotSearched) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Search Weather",
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500),
                          ),
                          const Text(
                            "Instantly",
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white70,
                                fontWeight: FontWeight.w200),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white70),
                            onChanged: (newValue) {
                              if (newValue.isNotEmpty) {
                                ScaffoldMessenger.of(context)
                                    .removeCurrentSnackBar();
                              }
                            },
                            decoration: InputDecoration(
                                hintText: "City Name",
                                hintStyle:
                                    const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.search),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.white70,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.blue,
                                      style: BorderStyle.solid),
                                )),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          getMaterialBtn(context, () {
                            String cityName = _searchController.text;
                            if (internetState is InternetConnected) {
                              if (cityName != "null".toUpperCase() &&
                                  cityName.isNotEmpty) {
                                context
                                    .read<WeatherBloc>()
                                    .add(FetchWeather(cityName: cityName));
                                clearTextField();
                              } else {
                                _showSnackBar(context, "Enter city name");
                              }
                            } else {
                              _showSnackBar(
                                context,
                                "No connection",
                              );
                              debugPrint("No connection");
                            }
                          }),
                        ],
                      ),
                    ),
                  );
                } else if (state is WeatherIsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherIsLoaded) {
                  return ShowWeatherPage(
                      weatherModel: state.weatherModel,
                      cityName: _searchController.text);
                } else if (state is WeatherIsNotLoaded) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Text(
                          "Place not found",
                          style: TextStyle(color: Colors.white70, fontSize: 32),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        getMaterialBtn(context, () {
                          context.read<WeatherBloc>().add(ResetWeather());
                        })
                      ],
                    ),
                  );
                } else {
                  return const Text("Place not found",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 32));
                }
              })
            ],
          ),
        ),
      ),
    );
  }

  _showSnackBar(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(),
        textAlign: TextAlign.center,
      ),
    ));
  }

  void clearTextField() {
    _searchController.text = "";
  }
}

class ShowWeatherPage extends StatelessWidget {
  const ShowWeatherPage(
      {Key? key, required this.weatherModel, required this.cityName})
      : super(key: key);
  final Main? weatherModel;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weatherModel!.currentTemp(),
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 40,
                fontWeight: FontWeight.w500),
          ),
          const Text(
            "Temperature",
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    weatherModel!.minTemp(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Min Temperature",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    weatherModel!.maxTemp(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Max Temperature",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          getMaterialBtn(context, () {
            context.read<WeatherBloc>().add(ResetWeather());
          })
        ],
      ),
    );
  }
}
