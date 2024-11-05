import 'package:flutter/material.dart';

class ViewScreen extends StatelessWidget {
  final String moodDetail;
  final String moodImagePath;
  const ViewScreen({super.key, required this.moodDetail, required this.moodImagePath});

  @override
  Widget build(BuildContext context) {
    final Color color = getColorBasedOnMood(moodDetail);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Face Mood Detector"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            Image.asset(
              moodImagePath,
              height: 200,
              width: 200,
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your Face's Mood is",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  moodDetail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getColorBasedOnMood(String mood) {
    switch (mood) {
      case "Happy":
        return Colors.green;
      case "Normal":
        return Colors.grey;
      case "Sad":
        return Colors.black54;
      case "Angry":
        return Colors.red;
      case "No Face Detected. Please try again!":
        return Colors.redAccent;
      default:
        return Colors.blueGrey; // لون افتراضي
    }
  }
}