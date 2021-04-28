import 'package:connectivity/connectivity.dart';

isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}
