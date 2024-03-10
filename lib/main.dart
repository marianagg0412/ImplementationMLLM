import 'package:flutter/material.dart';
import 'emotions.dart';
import 'images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => const MyHomePage(title: "My Home Page"),
        '/emotions': (context) => const EmotionsPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool emotionPageChecked = false;
  bool imagePageChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Column(
        children: [
          CheckboxListTile(
            title: Text('Go to Emotions Model'),
            value: emotionPageChecked,
            onChanged: (bool? value) {
              setState(() => emotionPageChecked = value!);
              if (value == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmotionsPage()),
                );
              }
            },
          ),
          CheckboxListTile(
            title: Text('Go to Images Model'),
            value: imagePageChecked,
            onChanged: (bool? value) {
              setState(() => imagePageChecked = value!);
              if (value == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImagesPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}