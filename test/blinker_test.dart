import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blinker/blinker.dart';

void main() {
  group('Blinker Widget Tests', () {
    testWidgets('Shimmer mode renders child', (WidgetTester tester) async {
      // Arrange
      const testKey = Key('shimmer_text');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Blinker.shimmer(
            key: Key('shimmer_widget'),
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Text('Hello Shimmer', key: testKey),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Hello Shimmer'), findsOneWidget);
    });

    testWidgets('Cycle mode renders child', (WidgetTester tester) async {
      // Arrange
      const testKey = Key('cycle_icon');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Blinker.cycle(
            key: const Key('cycle_widget'),
            colors: [Colors.red, Colors.green],
            child: Icon(Icons.star, key: testKey),
          ),
        ),
      );

      // Assert
      expect(find.byKey(testKey), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Blinker shimmer runs animation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Blinker.shimmer(
            baseColor: Colors.black,
            highlightColor: Colors.white,
            duration: Duration(milliseconds: 100),
            times: 1, // Only run one full cycle
            child: Text('Animating...'),
          ),
        ),
      );

      // Start animation
      await tester.pump();
      // Let animation run
      await tester.pump(const Duration(milliseconds: 200));

      // No crash means animation ran successfully
      expect(find.text('Animating...'), findsOneWidget);
    });
  });
}
