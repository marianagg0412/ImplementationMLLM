import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'SearchEntry.dart';
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
// Add a variable to hold the search history
  List<SearchEntry> searchHistory = [];
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
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
  
           // Save search to history after successful analysis
      SearchEntry entry = SearchEntry("images", fileName, DateTime.now(), _analysisResults ?? [], label: _analysisResults?[0]['label'], score: _analysisResults?[0]['score']);
      saveSearch(entry);
  // Actualizar la interfaz de usuario para mostrar el historial actualizado
      _updateSearchHistory();
      });
    }
  }
  void _updateSearchHistory() async {
  // Obtener el historial actualizado
  List<SearchEntry> updatedHistory = await getHistory();
  setState(() {
    searchHistory = updatedHistory;
  });
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
            if (!kIsWeb) ...[
              // Only show buttons on mobile platforms
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: const Text('Open Camera'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: const Text('Open Gallery'),
                  ),
                ],
              ),
            ] else ...[
              // Only show gallery button on web
              ElevatedButton(
                onPressed: () => _pickImage(ImageSource.gallery),
                child: const Text('Open Gallery'),
              ),
            ],
            if (_analysisResults != null)
              ..._analysisResults!.map((result) => Text('${result['label']}: ${(result['score'] * 100).toStringAsFixed(2)}%')),
          ],
        ),
      ),
    );
  }
}
