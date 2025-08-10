import 'package:flutter/material.dart';
import 'package:blinker/blinker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Blinker",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          leading: Icon(Icons.arrow_back, color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fade Mode",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),

                /// Fade Mode Example
                Blinker.fade(
                  startColor: Colors.white,
                  endColor: Colors.grey.withValues(alpha: 0.5),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: loadingListWidget(),
                ),

                Text(
                  "Cycle Mode",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),

                /// Cycle Mode Example
                Blinker.cycle(
                  colors: [
                    const Color(0xFF42A5F5), // Cool Blue
                    const Color(0xFF26C6DA), // Aqua Teal
                    const Color(0xFF66BB6A), // Fresh Green
                    const Color(0xFFFFCA28), // Warm Amber
                    const Color(0xFFEF5350), // Soft Red
                  ],
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  child: loadingListWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loadingListWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      color: Colors.black,
                    ),
                    Container(
                      height: 10,
                      width: 100,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
