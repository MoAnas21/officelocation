import 'package:flutter/material.dart';
import 'dart:ui';

class DeviceWidget extends StatelessWidget {
  final String deviceName;
  final String uuid;
  final String macAddress;
  final String scanTime;
  final String distance;
  final String rssi;

  const DeviceWidget(
      {required this.deviceName,
      required this.uuid,
      required this.macAddress,
      required this.scanTime,
      required this.distance,
      required this.rssi,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: IntrinsicHeight(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                // color: const Color.fromARGB(255, 126, 175, 128),
                color:
                    const Color.fromARGB(255, 173, 216, 255).withOpacity(0.2),
                border: Border.all(
                  color: const Color.fromARGB(255, 126, 157, 186)
                      .withOpacity(0.2), // Border color
                  width: 2, // Border width
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          deviceName,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'RSSI: $rssi',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 2.0,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'UUID: $uuid',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'MAC Address: $macAddress',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Scan Time: $scanTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Distance: $distance',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 15.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
