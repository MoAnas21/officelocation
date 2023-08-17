import 'package:flutter/material.dart';
import 'package:officelocation/splash.dart';
// import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 118, 163, 199)),
          useMaterial3: true,
        ),
        home: const SplashScreen()
        // const MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }
}
