import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class Connection extends ChangeNotifier {
  String connection = "";

  checkConnectivty() async {
    var result = await Connectivity().checkConnectivity();
    print('result'+result.toString());
    switch (result) {

      case ConnectivityResult.wifi:
        {
          connection = "Your mobile is connected with Wifi";
          break;
          notifyListeners();
        }
      case ConnectivityResult.mobile:
        {
          connection = "Your mobile is connected with mobile Internet";
          break;
          notifyListeners();
        }
      case ConnectivityResult.none:
        {
          connection = "Your mobile is no Internet Connection";
          notifyListeners();
        }
    }
  }
}
