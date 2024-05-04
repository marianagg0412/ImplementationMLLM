import 'package:flutter/material.dart';
import 'emotions.dart';
import 'images.dart';
import 'SearchEntry.dart'; // Assuming you have a separate file for search history logic (search_history.dart)

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

  // Add a state variable to store the retrieved search history
  List<SearchEntry> searchHistory = [];

  @override
  void initState() {
    super.initState();
    // Call getHistory() on widget initialization to fetch history
    getHistory().then((history) => setState(() => searchHistory = history));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Column(
        children: [
          // CheckboxListTile for emotions and images (unchanged)
          CheckboxListTile(
            title: const Text('Go to Emotions Model'),
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
            title: const Text('Go to Images Model'),
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

          // Add a button to display search history
             // Button to navigate to the SearchHistory widget
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchHistory(searchHistory: searchHistory)),
            ),
            child: const Text('Go to Historical'),
          ),
        ],
      ),
    );
  }
}

 // New widget to display search history
// Widget para mostrar el historial de búsqueda
class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key, required this.searchHistory}) : super(key: key);

  final List<SearchEntry> searchHistory;

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  List<SearchEntry> _currentHistory = [];

  @override
  void initState() {
    super.initState();
    _updateHistory();
  }

  Future<void> _updateHistory() async {
    List<SearchEntry> updatedHistory = await getHistory();
    setState(() {
      _currentHistory = updatedHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search History")),
      body: _currentHistory.isNotEmpty
          ? ListView.builder(
              itemCount: _currentHistory.length,
              itemBuilder: (context, index) {
                SearchEntry entry = _currentHistory[index];
                return ListTile(
                  title: Text('${entry.text} - ${entry.label ?? "No Label"} (${entry.score ?? 0.0})'), // Display search text, label, and score
                  subtitle: Text('${entry.type} - ${entry.date.toString()}'),
                );
              },
            )
          : const Center(child: Text('No search history found')),
    );
  }
}