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
  final TextEditingController _textController = TextEditingController();
  bool _isButtonDisabled = true;

  void _querySentiment() async {
    String text = _textController.text;
    if (text.trim().isEmpty) {
      return;
    }
    var data = await sentimentService.querySentiment(text);
    if (data != []) {
      setState(() {
        _sentiments = {};
        for (var entry in data) {
          if (entry['label'] != 'label' && entry['label'] != 'score') {
            _sentiments[entry['label']] = entry['score'];
          }
        }
      });
    } else{
      print("Hello");
    }
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
