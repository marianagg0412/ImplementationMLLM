import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_app/image_service.dart';

class Images extends StatefulWidget {
  const Images({super.key});

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  String _imagePath = "";
  Map<String, dynamic>? _analysisResult;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
        _analysisResult = null; // Clear previous analysis result
      });
    }
  }

  Future<void> analyzeImage() async {
    try {
      final imageService = ImageService(); // Create an instance
      final result = await imageService.analyzeImage(_imagePath);
      if (result != null) {
        setState(() {
          _analysisResult = result;
        });
      } else {
        // Handle the case where analysis result is null (e.g., show a message)
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Image analysis failed.')));
      }
    } catch (error) {
      // Handle errors appropriately (e.g., show an error message)
      ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('An error occurred: error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Analysis'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          if (_imagePath != null)
            Image.file(File(_imagePath!)),
          if (_analysisResult != null)
            Expanded( // Allow scrolling for potentially lengthy results
              child: ListView.builder(
                itemCount: _analysisResult!.length,
                itemBuilder: (context, index) {
                  final key = _analysisResult!.keys.elementAt(index);
                  final value = _analysisResult![key];
                  return ListTile(
                    title: Text(key),
                    subtitle: Text(value.toString()), // Handle different data types appropriately
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
