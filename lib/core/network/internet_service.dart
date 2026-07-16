import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../widgets/k_no_internet_dialog.dart';

class InternetService {
  InternetService._();

  static final InternetService instance = InternetService._();

  final Connectivity _connectivity = Connectivity();

  StreamSubscription? _subscription;

  /// Check internet once
  Future<bool> hasInternet() async {
    return await InternetConnection().hasInternetAccess;
  }

  /// Start listening
  void startListening() {
    _subscription?.cancel();

    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      final connected = await hasInternet();

      if (connected) {
        hideNoInternetDialog();
      } else {
        showNoInternetDialog();
      }
    });

    // Initial check
    Future.delayed(const Duration(milliseconds: 500), () async {
      final connected = await hasInternet();

      if (!connected) {
        showNoInternetDialog();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

/// Called from main.dart
void startInternetListener() {
  InternetService.instance.startListening();
}