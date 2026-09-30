# In-Class Activity 06 - CustomPainter Smiley

A Flutter application created for CSC 4360 Mobile App Development.

This activity focuses on using Flutter's `CustomPainter` and Canvas API to draw and interact with custom smiley faces.

## Features

- Custom smiley face drawn using `CustomPainter`
- Face, border, eyes, and mouth drawn with Canvas
- Mood slider that updates the face
- Face color changes based on mood
- Responsive drawing using the canvas size and face radius
- Three face styles:
  - Classic
  - Sleepy
  - Surprised
- Tap the face to cycle between face styles
- Long-press the face to randomize the mood
- SnackBar feedback for interactions
- Custom hat using Canvas drawing

## Flutter Concepts Used

- CustomPainter
- CustomPaint
- Canvas
- Paint
- drawCircle()
- drawArc()
- drawRRect()
- drawLine()
- StatefulWidget
- setState()
- GestureDetector
- Slider
- SnackBar
- shouldRepaint()

## Running the App

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

The application should be tested on an Android emulator or physical phone.

## Author

Eyobed Gebregziabher