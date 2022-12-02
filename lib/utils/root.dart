import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/auth_controller.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/pages/login_page.dart';

class Root extends GetWidget<AuthController> {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return (Get.find<AuthController>().user != null)
          ? const HomePage()
          : LoginPage();
    });
  }
}
