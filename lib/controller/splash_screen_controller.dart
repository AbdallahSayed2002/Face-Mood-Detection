import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home.dart';

abstract class SplashController extends GetxController {}

class SplashControllerImp extends SplashController with GetTickerProviderStateMixin {
  late final AnimationController animationController;
  late final AnimationController fadeController;
  late final Animation<double> fadeAnimation;

  @override
  void onInit() {
    animationController = AnimationController(vsync: this);
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    );

    startSplashScreenTimer();
    super.onInit();
  }

  Future<void> startSplashScreenTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    await fadeController.forward();
    Get.off(() => const Home(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    animationController.dispose();
    fadeController.dispose();
    super.dispose();
  }
}
