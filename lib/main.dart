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
  const SearchHistory({super.key, required this.searchHistory});

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
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: DataTable(
                    columns:const [
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Text')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Label')),
                      DataColumn(label: Text('Score')),
                    ],
                    rows: _currentHistory.map((entry) {
                      return DataRow(cells: [
                        DataCell(Text(entry.type)),
                        DataCell(Text(entry.text)),
                        DataCell(Text(entry.date.toString())),
                        DataCell(Text(entry.label ?? 'No Label')),
                        DataCell(Text(entry.score?.toString() ?? 'N/A')),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )
          : const Center(child: Text('No search history found')),
    );
  }
}
