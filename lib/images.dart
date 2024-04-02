import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_service.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker(); // Use a single ImagePicker instance
  final ImageService _imageService = ImageService();
  List<Map<String, dynamic>>? _analysisResults;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: await _getPreferredImageSource(), // Determine preferred source dynamically
    );

    if (pickedFile != null) {
      final Uint8List imageData = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });

      // Extract the filename (handle potential errors)
      String fileName = pickedFile.name;

      // Pass both imageData and fileName to the service for analysis
      List<Map<String, dynamic>>? analysisResults = await _imageService.analyzeImage(imageData, fileName);
      setState(() {
        _analysisResults = analysisResults;
        print(_analysisResults);
      });
    }
  }

  Future<ImageSource> _getPreferredImageSource() async { //Modify so it truly works
    if (kIsWeb) {
      return ImageSource.camera;
    } else {
      return ImageSource.camera;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Analysis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageData != null)
              Image.memory(_imageData!, width: 100, height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_analysisResults != null)
              ..._analysisResults!.map((result) => Text('${result['label']}: ${(result['score'] * 100).toStringAsFixed(2)}%')),
          ],
        ),
      ),
    );
  }
}