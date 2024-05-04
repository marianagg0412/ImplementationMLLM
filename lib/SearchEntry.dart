import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SearchEntry {
  final String type; // "emotions" or "images"
  final String text; // Text of the search (emotion or filename)
  final DateTime date;
  final List<Map<String, dynamic>> results;
  final String? label; // Label from the model
  final double? score; // Score from the model

  SearchEntry(this.type, this.text, this.date, this.results, {this.label, this.score});

  // Convert to JSON for storing
  Map<String, dynamic> toJson() => {
    'type': type,
    'text': text,
    'date': date.toIso8601String(),
    'results': results,
    'label': label, // Include label in JSON
    'score': score, // Include score in JSON
  };

  // Convert from JSON (handling potential errors)
  static SearchEntry fromJson(Map<String, dynamic> json) {
    try {
      return SearchEntry(
        json['type'],
        json['text'],
        DateTime.parse(json['date']),
        json['results']?.cast<Map<String, dynamic>>() ?? [],
        label: json['label'], // Retrieve label from JSON
        score: json['score'], // Retrieve score from JSON
      );
    } catch (error) {
      print("Error parsing SearchEntry: $error");
      // Handle the error gracefully, e.g., return a default SearchEntry
      return SearchEntry("", "", DateTime.now(), []);
    }
  }
}

// Function to get history asynchronously
Future<List<SearchEntry>> getHistory() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> historyJson = prefs.getStringList('history') ?? [];
  List<SearchEntry> searchHistory = [];

  try {
    searchHistory = historyJson.map((entry) => SearchEntry.fromJson(jsonDecode(entry))).toList();
    print("Search History:");
    searchHistory.forEach((entry) {
      print("Type: ${entry.type}, Text: ${entry.text}, Date: ${entry.date}, Label: ${entry.label}, Score: ${entry.score}");
    });
  } catch (error) {
    print("Error decoding history: $error");
  }

  return searchHistory;
}


// Function to save a new search entry (assuming you have logic to get results)
void saveSearch(SearchEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('history') ?? [];

  // Convertir el SearchEntry a JSON y agregarlo a la lista de historial
  history.add(jsonEncode(entry.toJson()));

  // Guardar la lista de historial actualizada en Shared Preferences
  prefs.setStringList('history', history);
}
