import 'dart:math';
import 'package:face_mood_detection/const.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/view_screen.dart';

// Enum to represent mood states
enum Mood { happy, normal, sad, angry, noFaceDetected }

// Controller for managing animations and face detection
abstract class HomeController extends GetxController {
  void initOuterCircleAnimation();
  void initMiddleCircleAnimation();
  void createTitleWidgets();
  void updateMood(double smilingProbability, double leftEyeOpenProbability,
      double rightEyeOpenProbability);
}

class HomeControllerImp extends HomeController with GetTickerProviderStateMixin {
  late AnimationController outerCircleController;
  late AnimationController middleCircleController;
  late Animation<double> outerCircleAnimation;
  late Animation<double> middleCircleAnimation;
  final Random _random = Random();
  RxString pathOfImage = "".obs;
  Rx<Mood> moodState = Mood.noFaceDetected.obs;
  RxBool isVisible = false.obs;
  RxBool isLoading = false.obs;
  final String title = "Face Mood Detection";
  RxList<Widget> titleWidgets = <Widget>[].obs;

  final FaceDetector detector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
      enableTracking: true,
    ),
  );

  final Map<Mood, String> moodImages = {
    Mood.happy: AppAssets.happy,
    Mood.normal: AppAssets.meh,
    Mood.sad: AppAssets.sad,
    Mood.angry: AppAssets.angry,
    Mood.noFaceDetected: AppAssets.noFace,
  };

  final Map<Mood, String> moodDescriptions = {
    Mood.happy: "Happy",
    Mood.normal: "Normal",
    Mood.sad: "Sad",
    Mood.angry: "Angry",
    Mood.noFaceDetected: "No Face Detected. Please try again!",
  };

  @override
  void onInit() {
    initOuterCircleAnimation();
    initMiddleCircleAnimation();
    createTitleWidgets();
    super.onInit();
  }

  @override
  void createTitleWidgets() {
    for (int i = 0; i < title.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        titleWidgets.add(
          Text(
            title[i],
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      });
    }
  }

  @override
  void updateMood(double smilingProbability, double leftEyeOpenProbability,
      double rightEyeOpenProbability) {
    if (smilingProbability >= 0.85 && leftEyeOpenProbability >= 0.95 &&
        rightEyeOpenProbability >= 0.85) {
      moodState.value = Mood.happy;
    } else if (smilingProbability <= 0.03 && leftEyeOpenProbability > 0.9 &&
        rightEyeOpenProbability > 0.9) {
      moodState.value = Mood.normal;
    } else if (smilingProbability <= 0.3 || leftEyeOpenProbability < 0.2) {
      moodState.value = Mood.sad;
    } else if (smilingProbability < 0.85 && smilingProbability >= 0.03 &&
        leftEyeOpenProbability >= 0.9 && rightEyeOpenProbability > 0.7) {
      moodState.value = Mood.angry;
    } else {
      moodState.value = Mood.angry;
    }
  }

  @override
  void initOuterCircleAnimation() {
    outerCircleController = AnimationController(
      duration: Duration(seconds: _random.nextInt(2) + 3),
      vsync: this,
    )..repeat(reverse: true);

    outerCircleAnimation = Tween<double>(
      begin: 1.0,
      end: _random.nextDouble() * 0.08 + 1.06,
    ).animate(
      CurvedAnimation(parent: outerCircleController, curve: Curves.easeInOut),
    );
  }

  @override
  void initMiddleCircleAnimation() {
    middleCircleController = AnimationController(
      duration: Duration(seconds: _random.nextInt(2) + 3),
      vsync: this,
    )..repeat(reverse: true);

    middleCircleAnimation = Tween<double>(
      begin: 1.0,
      end: _random.nextDouble() * 0.0699 + 1.07,
    ).animate(
      CurvedAnimation(parent: middleCircleController, curve: Curves.easeInOut),
    );
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    if (isLoading.value) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    isLoading.value = true;

    if (image != null) {
      pathOfImage.value = image.path;
      final probabilities = await extractData(image.path);

      Get.to(() => ViewScreen(
        moodDetail: "${moodDescriptions[moodState.value]}\n"
            "Smiling Probability: ${probabilities['smilingProbability']!.toStringAsFixed(2)}%\n",
        moodImagePath: moodImages[moodState.value] ?? "",
      ));
    }
    isLoading.value = false;
  }

  Future<Map<String, double>> extractData(String imagePath) async {
    isVisible.value = false;

    double smilingProbability = 0.0;
    double leftEyeOpenProbability = 0.0;
    double rightEyeOpenProbability = 0.0;

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await detector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces[0];
        smilingProbability = face.smilingProbability ?? 0.0;
        leftEyeOpenProbability = face.leftEyeOpenProbability ?? 0.0;
        rightEyeOpenProbability = face.rightEyeOpenProbability ?? 0.0;

        updateMood(smilingProbability, leftEyeOpenProbability,
            rightEyeOpenProbability);
        isVisible.value = true;
      } else {
        moodState.value = Mood.noFaceDetected;
      }
    } catch (e) {
      moodState.value = Mood.noFaceDetected;
      if (kDebugMode) {
        print("Error processing image: $e");
      }
    } finally {
      isLoading.value = false;  // Ensure loading is turned off in case of an error
    }

    return {

    };
  }

  @override
  void dispose() {
    outerCircleController.dispose();
    middleCircleController.dispose();
    detector.close();
    super.dispose();
  }
}
