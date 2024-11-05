import 'package:face_mood_detection/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controller/home-controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeControllerImp controller = Get.put(HomeControllerImp());

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Outer Circle Animation
                      AnimatedBuilder(
                        animation: controller.outerCircleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.outerCircleAnimation.value,
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[100],
                              ),
                            ),
                          );
                        },
                      ),
                      // Middle Circle Animation
                      AnimatedBuilder(
                        animation: controller.middleCircleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.middleCircleAnimation.value,
                            child: Container(
                              width: 175,
                              height: 175,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[300],
                              ),
                            ),
                          );
                        },
                      ),
                      // Floating Action Button for Camera
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: FloatingActionButton(
                          onPressed: () {
                            controller.pickImage(fromCamera: true);
                          },
                          shape: const CircleBorder(),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          heroTag: null,
                          child: const Icon(CupertinoIcons.camera_fill, size: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: controller.titleWidgets.value,
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      // Outer Circle Animation
                      AnimatedBuilder(
                        animation: controller.outerCircleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.outerCircleAnimation.value,
                            child: Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[100],
                              ),
                            ),
                          );
                        },
                      ),
                      // Middle Circle Animation
                      AnimatedBuilder(
                        animation: controller.middleCircleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: controller.middleCircleAnimation.value,
                            child: Container(
                              width: 175,
                              height: 175,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[300],
                              ),
                            ),
                          );
                        },
                      ),
                      // Floating Action Button for Gallery
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: FloatingActionButton(
                          onPressed: () {
                            controller.pickImage(fromCamera: false);
                          },
                          shape: const CircleBorder(),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          heroTag: null,
                          child: const Icon(
                              CupertinoIcons.photo_fill_on_rectangle_fill,
                              size: 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Loading Overlay
          Obx(
                () => controller.isLoading.value
                ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(AppAssets.loading, width: 250, height: 250),
                    const Text(
                      'Processing...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
