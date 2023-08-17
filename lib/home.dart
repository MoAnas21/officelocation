import 'package:flutter/material.dart';
import 'device.dart';
// import 'map.dart';
import 'advert.dart';
import 'ble.dart';
import 'notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// class BeaconsScan {
//   List<List<String>> data = [];
//   final position = 0.0;
// }

class _MyHomePageState extends State<MyHomePage> {
  BeaconsScan beacon = BeaconsScan();
  NotificationServices notification = NotificationServices();

  List<String> nearbyBeacon = [];
  bool isScaning = false;

  bool showAd = false;
  String? adMac;

  void initiateScan() async {
    await beacon.initiateBeacon();
  }

  void initiateNotification() async {
    InitializationSettings initializationSettings = notification.initialize();
    await notification.flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        // onDidReceiveBackgroundNotificationResponse: handleNotificationTap,
        onDidReceiveNotificationResponse: handleNotificationTap);
    // final NotificationAppLaunchDetails? launchDetails = await notification
    //     .flutterLocalNotificationsPlugin
    //     .getNotificationAppLaunchDetails();

    // if (launchDetails?.didNotificationLaunchApp ?? false) {
    //   handleNotificationTap(launchDetails!.notificationResponse!.id);
    // }
  }

  void handleNotificationTap(NotificationResponse? details) {
    for (String mac in mactoposition.keys) {
      if (mactoposition[mac] == details!.id) {
        adMac = mac;
      }
    }
    showAd = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initiateScan();
    initiateNotification();
  }

  void startScan() {
    isScaning = true;
    beacon.readScan();
    beacon.controllerData.stream.listen((data) {
      showNotification();
      setState(() {});
    });
    beacon.controllerPosition.stream.listen((data) {
      setState(() {});
    });
  }

  void showNotification() {
    for (List<String> data in beacon.data) {
      if (int.parse(data[5]) > -60) {
        if (nearbyBeacon.contains(data[2])) {
          continue;
        } else {
          notification.showNotification(mactoposition[data[2]] ?? 0,
              "Beacon Found", "Found Beacon has MAC Address ${data[2]}");
        }
        nearbyBeacon.add(data[2]);
      }
      // else {
      //   if (nearbyBeacon.contains(data[2])) {
      //     notification.deleteNotification(
      //         nearbyBeacon.indexWhere((item) => item == data[2]));
      //     nearbyBeacon.remove(data[2]);
      //   }
      // }
    }
  }

  void addBlock() {
    beacon.data.add(["", "", "", "", "", "", ""]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: const Color.fromARGB(255, 118, 163, 199),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor:
              Colors.transparent, // const Color.fromARGB(255, 118, 162, 199),
          title: Center(child: Text(widget.title)),
          // clipBehavior: Clip.antiAlias,
          // shape: const RoundedRectangleBorder(
          //     borderRadius:
          //         BorderRadius.vertical(bottom: Radius.circular(20.0))),
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(25)),
              child: Container(
                color: const Color.fromARGB(255, 118, 162, 199),
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 255, 250, 201),
                Color.fromARGB(255, 251, 250, 242),
                Color.fromARGB(255, 255, 250, 201)
              ])),
          child: Center(
            child: ListView(
              children: [
                const SizedBox(height: 16.0), // Spacer
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: Center(
                //     child: Container(
                //       height: 300.0,
                //       width: MediaQuery.of(context).size.width,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(25),
                //         color: const Color.fromARGB(255, 173, 216, 255)
                //             .withOpacity(0.2),
                //         border: Border.all(
                //           color: const Color.fromARGB(255, 126, 157, 186)
                //               .withOpacity(0.2), // Border color
                //           width: 2,
                //         ),
                //       ),
                //       child: Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 16.0, vertical: 8.0),
                //         child: CustomPaint(
                //           painter: MapPainter(position: beacon.position ?? 0.0),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                // Expanded(
                //   child:
                //   ListView.builder(
                //     itemCount: beacon.data.length,
                //     itemBuilder: (context, index) {
                //       return DeviceWidget(
                //         deviceName: beacon.data[index][0],
                //         uuid: beacon.data[index][1],
                //         macAddress: beacon.data[index][2],
                //         scanTime: beacon.data[index][3],
                //         distance: beacon.data[index][4],
                //         rssi: beacon.data[index][5],
                //       );
                //     },
                //   ),
                // ),
                ...beacon.data
                    .map((data) => GestureDetector(
                        onTap: () {
                          adMac = data[2];
                          showAd = true;
                          setState(() {});
                        },
                        child: DeviceWidget(
                          deviceName: data[0],
                          uuid: data[1],
                          macAddress: data[2],
                          scanTime: data[3],
                          distance: data[4],
                          rssi: data[5],
                        )))
                    .toList()
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          color: const Color.fromARGB(255, 118, 163, 199).withOpacity(0.8),
          height: 40,
          shadowColor: const Color.fromARGB(255, 118, 163, 199),
        ),
        floatingActionButton: isScaning
            ? const FloatingActionButton(
                onPressed: null,
                tooltip: 'Increment',
                backgroundColor: Colors.grey,
                shape: CircleBorder(),
                child: Icon(Icons.start),
              )
            : FloatingActionButton(
                onPressed: startScan,
                tooltip: 'Increment',
                backgroundColor: const Color.fromARGB(255, 118, 163, 199),
                shape: const CircleBorder(),
                child: const Icon(Icons.start),
              ),
        //     FloatingActionButton(
        //   onPressed: addBlock,
        //   tooltip: 'Increment',
        //   backgroundColor: const Color.fromARGB(255, 118, 163, 199),
        //   shape: const CircleBorder(),
        //   child: const Icon(Icons.navigation),
        // ),
      ),
      Visibility(
        visible: showAd,
        child: Stack(children: [
          GestureDetector(
            onTap: () {
              adMac = null;
              showAd = false;
              setState(() {});
            },
            child: Container(
              color: Colors.black54,
              alignment: Alignment.center,
            ),
          ),
          Advert(macAd: adMac ?? "Hey"),
        ]),
      ),
    ]);
  }
}
