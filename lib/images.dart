import 'dart:typed_data';
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
  final ImageService _imageService = ImageService();
  List<Map<String, dynamic>>? _analysisResults;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageData = await pickedFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });

      // Extract the file name
      String fileName = pickedFile.name;

      // Pass both imageData and fileName to the service
      List<Map<String, dynamic>>? analysisResults = await _imageService.analyzeImage(imageData, fileName);
      setState(() {
        _analysisResults = analysisResults;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Analysis'),
      ),
      body: Center( // Wrap the Column in a Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center children vertically
          children: [
            if (_imageData != null)
              Image.memory(_imageData!, width: 100, height: 100),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image from Gallery'),
            ),
            if (_analysisResults != null)
              ..._analysisResults!.map((result) => Text('${result['label']}: ${(result['score'] * 100).toStringAsFixed(2)}%')).toList(),
          ],
        ),
      ),
    );
  }

}
