import 'package:coffee/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    // เรียกฟังก์ชันดึงข้อมูลกาแฟเมื่อเริ่มต้น
    final ctrl = Get.find<CoffeeController>();
    ctrl.fetchCoffees();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoffeeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ctrl.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        // ใช้ Obx เพื่อให้ UI อัปเดตตามการเปลี่ยนแปลงของรายการกาแฟ
        if (ctrl.coffees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: ctrl.coffees.length,
          itemBuilder: (context, index) {
            final coffee = ctrl.coffees[index];
            return ListTile(
              title: Text(coffee['name'] ?? 'No Name'),
              subtitle: Text(coffee['description'] ?? 'No Description'),
              trailing: Text('${coffee['price'] ?? '0'} ฿'),
            );
          },
        );
      }),
    );
  }
}