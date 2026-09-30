// In-Class Activity 06 — Drawing with Flutter
// Student: Eyobed Gebregziabher
// Date: September 30, 2026

import 'dart:math' show pi, Random;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

enum FaceType { classic, sleepy, surprised }

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType selectedFace = FaceType.classic;

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
  }

  void changeFace(FaceType face) {
    setState(() {
      selectedFace = face;
    });

    showMessage('${face.name.toUpperCase()} face selected');
  }

  void cycleFace() {
    final currentIndex = FaceType.values.indexOf(selectedFace);
    final nextIndex = (currentIndex + 1) % FaceType.values.length;

    setState(() {
      selectedFace = FaceType.values[nextIndex];
    });

    showMessage('Changed to ${selectedFace.name.toUpperCase()}');
  }

  void randomizeMood() {
    final random = Random();

    setState(() {
      mood = random.nextDouble();
    });

    showMessage('Mood randomized to ${mood.toStringAsFixed(2)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: cycleFace,
                  onLongPress: randomizeMood,
                  child: CustomPaint(
                    size: const Size(300, 300),
                    painter: SmileyPainter(mood: mood, faceType: selectedFace),
                  ),
                ),
              ),
            ),

            Text(
              selectedFace.name.toUpperCase(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Tap face to cycle • Long-press to randomize',
              style: TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    changeFace(FaceType.classic);
                  },
                  child: const Text('Classic'),
                ),
                ElevatedButton(
                  onPressed: () {
                    changeFace(FaceType.sleepy);
                  },
                  child: const Text('Sleepy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    changeFace(FaceType.surprised);
                  },
                  child: const Text('Surprised'),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Column(
                children: [
                  Text(
                    'Mood: ${mood.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Slider(
                    value: mood,
                    min: 0,
                    max: 1,
                    onChanged: (double value) {
                      setState(() {
                        mood = value;
                      });
                    },
                  ),

                  Text(
                    mood < 0.35
                        ? 'Sad'
                        : mood <= 0.70
                        ? 'Okay'
                        : 'Happy',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood, required this.faceType});

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.shortestSide * 0.40;

    // FACE COLOR BASED ON MOOD
    final Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue.shade300;
    } else if (mood <= 0.70) {
      faceColor = Colors.yellow.shade600;
    } else {
      faceColor = Colors.orange.shade400;
    }

    // FACE
    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    // BORDER
    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, borderPaint);

    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    final eyeStrokePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.20;
    final eyeDistance = radius * 0.35;
    final eyeRadius = radius * 0.08;

    // DIFFERENT EYES FOR EACH FACE
    if (faceType == FaceType.sleepy) {
      final leftEyeRect = Rect.fromCenter(
        center: Offset(center.dx - eyeDistance, eyeY),
        width: radius * 0.25,
        height: radius * 0.15,
      );

      final rightEyeRect = Rect.fromCenter(
        center: Offset(center.dx + eyeDistance, eyeY),
        width: radius * 0.25,
        height: radius * 0.15,
      );

      canvas.drawArc(leftEyeRect, 0, pi, false, eyeStrokePaint);

      canvas.drawArc(rightEyeRect, 0, pi, false, eyeStrokePaint);
    } else {
      double currentEyeRadius = eyeRadius;

      if (faceType == FaceType.surprised) {
        currentEyeRadius = radius * 0.12;
      }

      canvas.drawCircle(
        Offset(center.dx - eyeDistance, eyeY),
        currentEyeRadius,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDistance, eyeY),
        currentEyeRadius,
        eyePaint,
      );
    }

    // MOUTH
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if (faceType == FaceType.surprised) {
      canvas.drawCircle(
        Offset(center.dx, center.dy + radius * 0.28),
        radius * 0.18,
        mouthPaint,
      );
    } else if (faceType == FaceType.sleepy) {
      final sleepyMouth = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.30),
        width: radius * 0.55,
        height: radius * 0.25,
      );

      canvas.drawArc(sleepyMouth, 0.15 * pi, 0.70 * pi, false, mouthPaint);
    } else {
      final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.18),
        width: radius,
        height: radius * (0.40 + mood * 0.50),
      );

      if (mood < 0.35) {
        final frownRect = mouthRect.translate(0, radius * 0.25);

        canvas.drawArc(frownRect, 1.15 * pi, 0.70 * pi, false, mouthPaint);
      } else if (mood <= 0.70) {
        canvas.drawArc(mouthRect, 0.15 * pi, 0.70 * pi, false, mouthPaint);
      } else {
        final happyRect = Rect.fromCenter(
          center: Offset(center.dx, center.dy + radius * 0.12),
          width: radius * 1.15,
          height: radius * 0.85,
        );

        canvas.drawArc(happyRect, 0.15 * pi, 0.70 * pi, false, mouthPaint);
      }
    }

    // HAT
    final hatPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final hatRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius * 0.95),
      width: radius * 1.15,
      height: radius * 0.32,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(hatRect, const Radius.circular(8)),
      hatPaint,
    );

    final brimPaint = Paint()
      ..color = Colors.indigo.shade900
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - radius * 0.70, center.dy - radius * 0.80),
      Offset(center.dx + radius * 0.70, center.dy - radius * 0.80),
      brimPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood || oldDelegate.faceType != faceType;
  }
}
