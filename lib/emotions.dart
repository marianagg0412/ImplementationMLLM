import 'package:flutter/material.dart';
import 'package:test_app/sentiment_service.dart';

class EmotionsPage extends StatefulWidget {
  const EmotionsPage({super.key});

  @override
  _EmotionsPageState createState() => _EmotionsPageState();
}

class _EmotionsPageState extends State<EmotionsPage> {
  Map<String, double> _sentiments = {};
  SentimentService sentimentService = SentimentService();

  void _querySentiment(String text) async {
    try {
      var data = await sentimentService.querySentiment(text);
      setState(() {
        _sentiments = {};
        int count = 0;
        while(count < 3) {
          for (var entry in data) {
            if (entry['label'] != 'label' && entry['label'] != 'score') {
              print(entry['label']);
              print(entry['score']);
              _sentiments[entry['label']] = entry['score'];
              count++;
            }
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emotions'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Enter text'),
            onSubmitted: _querySentiment,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _sentiments.keys.length,
              itemBuilder: (context, index) {
                String emotion = _sentiments.keys.elementAt(index);
                double score = _sentiments[emotion] ?? 0.0; // Ensure a default value in case of null
                return ListTile(
                  title: SelectableText('Label: "$emotion"\nScore: "${(score * 100).toStringAsFixed(2)}%"'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}