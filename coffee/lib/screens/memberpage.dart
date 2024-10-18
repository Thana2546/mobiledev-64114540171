import 'package:coffee/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Memberpage extends StatelessWidget {
  const Memberpage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CoffeeController>();
    
    ctrl.fetchCoffees();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Member Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ctrl.logout(); // เรียกใช้ฟังก์ชัน logout
            },
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.coffees.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: ctrl.coffees.length,
          itemBuilder: (context, index) {
            final coffee = ctrl.coffees[index];
            print(coffee);

            final coffeeId = coffee['id'];

            return ListTile(
              title: Text(coffee['name'] ?? 'No Name'),
              subtitle: Text(coffee['description']?? 'No Description'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${coffee['price']} ฿'),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (coffeeId != null && coffeeId is String) {
                        ctrl.deleteCoffee(coffeeId);
                      } else {
                        print('Error: coffee id is null');
                        Get.snackbar('Delete Failed', 'Coffee ID is invalid or null', snackPosition: SnackPosition.BOTTOM);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // แสดง Dialog สำหรับการเพิ่มข้อมูลกาแฟ
          showDialog(
            context: context,
            builder: (context) {
              String name = '';
              String description = '';
              double price = 0;

              return AlertDialog(
                title: const Text('Add Coffee'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        price = double.tryParse(value) ?? 0;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // ปิด Dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // เรียกฟังก์ชันเพิ่มกาแฟ
                      ctrl.addCoffee(name, description, price);
                      Navigator.pop(context); // ปิด Dialog หลังเพิ่ม
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}