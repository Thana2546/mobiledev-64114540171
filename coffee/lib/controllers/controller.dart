import 'package:coffee/screens/landdingpage.dart';
import 'package:coffee/screens/loginpage.dart';
import 'package:coffee/screens/memberpage.dart';
import 'package:coffee/screens/welcomepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pocketbase/pocketbase.dart';

class CoffeeController extends GetxController {
  var appname = 'Coffee'.obs;
  var isAdmin = false.obs;
  final pb = PocketBase('http://127.0.0.1:8090');
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var coffees = <Map<String, dynamic>>[].obs;

  Future<void> authen(String email, String password) async {
    try {
      final res = await pb.admins.authWithPassword(email, password);
      isAdmin.value = true;
      if (pb.authStore.isValid) {
        print('Admin logged in: $email');
        Get.to(() => const Memberpage());
      }
    } catch (e) {
      print('Admin login error: $e');
    }

    try {
      final res =
          await pb.collection('users').authWithPassword(email, password);
      isAdmin.value = false;
      if (pb.authStore.isValid) {
        print('User logged in: $email');
        Get.to(() => const LandingPage());
      }
    } catch (e) {
      print('User login error: $e');
    }
  }

  Future<void> register(String username, String email, String name,
      String password, String passwordConfirm) async {
    try {
      if (password != passwordConfirm) {
        throw Exception('password not match');
      }
      final body = {
        'username': username,
        'email': email,
        'name': name,
        'password': password,
        'passwordConfirm': passwordConfirm
      };
      await pb.collection('users').create(body: body);
      Get.snackbar('Success', 'Registration successful',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAll(() => const Loginpage());
    } catch (e) {
      print('Registration error: $e');
      Get.snackbar(
          'Registration Failed', 'An error occurred during registration.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    try {
      // ทำการ logout
      pb.authStore.clear(); // เคลียร์การพิสูจน์ตัวตน
      print('User logged out');
      Get.offAll(() => const Welcomepage()); // เปลี่ยนไปยังหน้า Welcomepage
    } catch (e) {
      print('Logout error: $e');
      Get.snackbar('Logout Failed', 'An error occurred during logout.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchCoffees() async {
    try {
      final res = await pb.collection('coffees').getFullList();
      coffees.value = res.map((coffee) => {
      'id': coffee.id,
      'name': coffee.data['name'],
      'description': coffee.data['description'],
      'price': coffee.data['price'],
    }).toList();
    } catch (e) {
      print('Fetch error: $e');
      Get.snackbar('Error', 'Unable to fetch items',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addCoffee(String name, String description, double price) async {
    try {
      final body = {'name': name, 'description': description, 'price': price};
      await pb.collection('coffees').create(body: body);
      await fetchCoffees();
      Get.snackbar('Success', 'Coffee added successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      print('Error adding coffee: $e');
      Get.snackbar('Error', 'Failed to add coffee.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteCoffee(String id) async {
    if (pb.authStore.model == null || !pb.authStore.isValid) {
      Get.offAll(() => const Loginpage());
      return;
    }
    if (id == null || id.isEmpty) {
      Get.snackbar('Error', 'No ID', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await pb.collection('coffees').delete(id);
      Get.snackbar('Success', 'Delete Scccess',
          snackPosition: SnackPosition.BOTTOM);
      await fetchCoffees();
    } catch (e) {
      Get.snackbar('Error', 'failed', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
