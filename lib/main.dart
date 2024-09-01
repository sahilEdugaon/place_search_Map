import 'package:final_taxi_app/views/bottom_nav/bottom_nav.dart';
import 'package:final_taxi_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('my_box');
  await Hive.openBox('details');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box('details');

    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: box.get('token') == null || box.get('token').toString().isEmpty
        ? const SplashScreen()
        :const BottomNavigationScreen(),
    );
  }
}
