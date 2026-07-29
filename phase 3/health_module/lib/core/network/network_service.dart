import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();

  Future<bool> isOnline() async {
    try {
      final ConnectivityResult result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.mobile || 
          result == ConnectivityResult.wifi || 
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn) {
        return true;
      }
      return false;
    } catch (e) {
      // Fallback to true if there's a platform exception during check, 
      // API call will naturally fail and we'll handle it there.
      return true; 
    }
  }

  Stream<ConnectivityResult> get onConnectivityChanged => _connectivity.onConnectivityChanged;
}
