import 'dart:html';

import 'package:flutter/material.dart';
import 'package:test_app/sentiment_service.dart';
import 'SearchEntry.dart';

class EmotionsPage extends StatefulWidget {
  const EmotionsPage({super.key});

  @override
  _EmotionsPageState createState() => _EmotionsPageState();
}

class _EmotionsPageState extends State<EmotionsPage> {
  Map<String, double> _sentiments = {};
  SentimentService sentimentService = SentimentService();
  final TextEditingController _textController = TextEditingController();
  bool _isButtonDisabled = true;
  String val = "";
// Add a variable to hold the search history
  List<SearchEntry> searchHistory = [];
  void _querySentiment() async {
    String text = _textController.text;
    if (text.trim().isEmpty) {
      return;
    }
    var data = await sentimentService.querySentiment(text);
    if (data != []) {
      String label;
      double score;
      bool firstIteration = true;
      
      setState(() {
        _sentiments = {};
        for (var entry in data) {
          if (entry['label'] != 'label' && entry['label'] != 'score') {
            _sentiments[entry['label']] = entry['score']; 
            if(firstIteration){
              label = entry['label'];
              score = entry['score'];

              SearchEntry searchEntry = SearchEntry("emotions",val ,DateTime.now(), data, label: label, score: score);
              saveSearch(searchEntry);
              // Actualizar la interfaz de usuario para mostrar el historial actualizado
          _updateSearchHistory();
            }
          }
        }
    
      });
    } else{
      print("Hello");
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
        title: const Text('Emotions'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(labelText: 'Enter text'),
            onChanged: (value) {
              setState(() {
                val = value;
                _isButtonDisabled = value.trim().isEmpty;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _sentiments.keys.length,
                itemBuilder: (context, index) {
                  String emotion = _sentiments.keys.elementAt(index);
                  double score = _sentiments[emotion] ?? 0.0;
                  return ListTile(
                    title: SelectableText(
                        'Label: "$emotion"\nScore: "${(score * 100).toStringAsFixed(2)}%"'),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: _isButtonDisabled ? null : _querySentiment,
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}