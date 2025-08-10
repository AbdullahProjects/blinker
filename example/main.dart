import 'package:flutter/material.dart';
import 'package:blinker/blinker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Blinker Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Blinker.shimmer(
                child: const Text(
                  'Shimmer Blink',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                startColor: Colors.grey,
                endColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Blinker.cycle(
                child: const Icon(Icons.star, size: 64),
                colors: [Colors.red, Colors.orange, Colors.yellow],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
