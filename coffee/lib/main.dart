import 'package:coffee/screens/loginpage.dart';
import 'package:coffee/screens/registerpage.dart';
import 'package:coffee/screens/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/controller.dart';

void main() {
  print('running App');
  Get.put(CoffeeController()); 
  runApp(const CoffeeApp());
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Welcomepage()),
        GetPage(name: '/Loginpage', page: () => const Loginpage()),
        GetPage(name: '/Registerpage', page: ()=> const Registerpage()),
      ],
    );
  }
}