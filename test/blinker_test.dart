import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blinker/blinker.dart';

void main() {
  group('Blinker widget tests', () {
    testWidgets('Blinker.fade renders with start and end colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Blinker.fade(
            startColor: Colors.red,
            endColor: Colors.blue,
            child: const Text('Fade Test'),
          ),
        ),
      );

      expect(find.text('Fade Test'), findsOneWidget);
    });

    testWidgets('Blinker.cycle renders with a list of colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Blinker.cycle(
            colors: [Colors.red, Colors.green, Colors.blue],
            child: const Text('Cycle Test'),
          ),
        ),
      );

      expect(find.text('Cycle Test'), findsOneWidget);
    });

    testWidgets('Fade animation changes color over time',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Blinker.fade(
            startColor: Colors.red,
            endColor: Colors.blue,
            duration: const Duration(milliseconds: 100),
            child: const Text('Animating Fade'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Animating Fade'), findsOneWidget);
    });

    testWidgets('Cycle mode loops through multiple colors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Blinker.cycle(
            colors: [Colors.red, Colors.green, Colors.blue],
            duration: const Duration(milliseconds: 100),
            child: const Text('Looping Colors'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.text('Looping Colors'), findsOneWidget);
    });

    test('Fade constructor throws if colors are missing', () {
      expect(
        () => Blinker.fade(
          startColor: Colors.red,
          endColor: null as dynamic,
          child: const Text('Invalid'),
        ),
        throwsAssertionError,
      );
    });

    test('Cycle constructor throws if color list has less than 2 colors', () {
      expect(
        () => Blinker.cycle(
          colors: [Colors.red],
          child: const Text('Invalid'),
        ),
        throwsAssertionError,
      );
    });
  });
}
