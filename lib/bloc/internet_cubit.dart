import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_jk/bloc/internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  late StreamSubscription connectivityStreamSubscription;
  Connectivity connectivity;

  InternetCubit(InternetState initialState, {required this.connectivity})
      : super(InternetLoading()) {
    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        emitInternetConnected();
      } else if (connectivityResult == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    });
  }

  /// internet connected
  void emitInternetConnected() => emit(InternetConnected());

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
