import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetStatus> {
  InternetCubit() : super(const InternetStatus(ConnectivityStatus.checking)) {
    checkConnectivity();
    trackConnectivityChange();
  }

  Timer? _timer;
  ConnectivityStatus? _lastStatus;
  bool _shouldRepeat = false;

  void checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    await _updateConnectivityStatus(connectivityResult);
  }

  Future<void> _updateConnectivityStatus(ConnectivityResult result) async {
    ConnectivityStatus newStatus;

    if (result == ConnectivityResult.none) {
      newStatus = ConnectivityStatus.disconnected;
    } else {
      newStatus = await checkInternetAccess()
          ? ConnectivityStatus.connected
          : ConnectivityStatus.disconnected;
    }

    if (_lastStatus == null || newStatus != _lastStatus) {
      emit(InternetStatus(newStatus));
    }

    _lastStatus = newStatus;

    if (newStatus == ConnectivityStatus.disconnected) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  Future<bool> checkInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          // ignore: prefer_const_constructors
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _startTimer() {
    _shouldRepeat = true;
    _timer?.cancel();
    // ignore: prefer_const_constructors
    _timer = Timer.periodic(Duration(seconds: 12), (timer) async {
      if (_shouldRepeat) {
        var connectivityResult = await Connectivity().checkConnectivity();
        await _updateConnectivityStatus(connectivityResult);
        // ignore: prefer_const_constructors
        emit(InternetStatus(ConnectivityStatus.disconnected));
      }
    });
  }

  void _stopTimer() {
    _shouldRepeat = false;
    _timer?.cancel();
    _timer = null;
  }

  late StreamSubscription _subscription;
  void trackConnectivityChange() {
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      await _updateConnectivityStatus(result);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _stopTimer();
    return super.close();
  }
}
