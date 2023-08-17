import 'package:beacons_plugin/beacons_plugin.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import 'dart:math';

const mactoposition = {
  "AC:23:3F:7A:78:D9": 1,
  "AC:23:3F:F6:70:00": 2,
  "AC:23:3F:6F:B8:09": 3
};

class BeaconsScan {
  List<List<String>> data = [];
  final controllerData = StreamController<List<List<String>>>();
  double? position;
  final controllerPosition = StreamController<double>();
  List<int> rssiMap = [0, 0, 0];
  final StreamController<String> beaconEventsController =
      StreamController<String>.broadcast();

  BeaconsScan();

  Future<void> initiateBeacon() async {
    BeaconsPlugin.addRegion("myBeacon", "01022022-f88f-0000-00ae-9605fd9bb620")
        .then((result) {}); // add UUID

    //run in background
    await BeaconsPlugin.runInBackground(true);

    if (Platform.isAndroid) {
      //Prominent disclosure
      await BeaconsPlugin.clearDisclosureDialogShowFlag(true);
      await BeaconsPlugin.setDisclosureDialogMessage(
          title: "Need Location Permission",
          message: "This app collects location data to work with beacons.");
      // await BeaconsPlugin.clearDisclosureDialogShowFlag(true);

      await Permission.location.request();
      if (await Permission.location.isGranted) {
        //print("Permission Granted");
      }

      BeaconsPlugin.channel.setMethodCallHandler((call) async {
        if (call.method == 'isPermissionDialogShown') {
          await BeaconsPlugin.startMonitoring();
        } else if (call.method == 'scannerReady') {
          await BeaconsPlugin.startMonitoring();
        } else {}
      });
    } else if (Platform.isIOS) {
      await BeaconsPlugin.startMonitoring();
    }
  }

  void readScan() {
    BeaconsPlugin.listenToBeacons(beaconEventsController);
    beaconEventsController.stream.listen((data) {
      updateData(data);
      controllerData.add(this.data);
    }, onDone: () {}, onError: (error) {});
  }

  void updateData(String str) {
    var temp = str.split(",");
    var dev = [
      temp[0].split(": ")[1].substring(1, temp[0].split(": ")[1].length - 1),
      temp[1].split(": ")[1].substring(1, temp[1].split(": ")[1].length - 1),
      temp[2].split(": ")[1].substring(1, temp[2].split(": ")[1].length - 1),
      temp[7].split(": ")[1].substring(1, temp[7].split(": ")[1].length - 1),
      temp[5].split(": ")[1].substring(1, temp[5].split(": ")[1].length - 1),
      temp[8].split(": ")[1].substring(1, temp[8].split(": ")[1].length - 1)
    ];
    if (dev[2].contains("AC:23:3F")) {
      var flag = true;
      for (int i = 0; i < data.length; i++) {
        if (data[i][2] == dev[2]) {
          flag = false;
          data[i][3] = dev[3];
          data[i][4] = dev[4];
          data[i][5] = dev[5];
          rssiMap[mactoposition[dev[2]]! - 1] = 100 + int.parse(dev[5]);
        }
      }
      if (flag) {
        dev[0] = "Beacon #${mactoposition[dev[2]] ?? data.length}";
        rssiMap[mactoposition[dev[2]]! - 1] = 100 + int.parse(dev[5]);
        data.add(dev);
      }
      // print(data);
      determinePosition();
    }
  }

  void determinePosition() {
    int maxIndex = 0;
    bool plusMinus = true;
    for (int i = 0; i < rssiMap.length; i++) {
      if (rssiMap[i] > rssiMap[maxIndex]) maxIndex = i;
    }
    if (maxIndex == rssiMap.length - 1) {
      plusMinus = false;
    } else if (maxIndex == 0) {
      plusMinus = true;
    } else if (rssiMap[maxIndex + 1] < rssiMap[maxIndex - 1]) {
      plusMinus = false;
    }
    if (plusMinus) {
      position = (1 / (rssiMap.length - 1)) * (maxIndex) +
          ((1 / (2 * (rssiMap.length - 1)))) *
              pow(((70 - rssiMap[maxIndex] + rssiMap[maxIndex + 1]) / 70), 3);
    }
    controllerPosition.add(position ?? 0.0);
  }
}
