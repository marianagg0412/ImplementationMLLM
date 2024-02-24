import 'dart:convert';
import 'package:http/http.dart' as http;

class SentimentService {
  Future<List<Map<String, dynamic>>> querySentiment(String text) async {
    var url = Uri.parse('http://127.0.0.1:5000/api/model-1'); //change url
    var response = await http.post(url,
        body: jsonEncode({'inputs': text}), // Encode the body as JSON
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      print(list);
      var nestedList = list[0] as List;
      List<Map<String, dynamic>> firstThree =
      nestedList.take(3).map((e) => e as Map<String, dynamic>).toList();
      return firstThree;
    } else {
      throw Exception('Failed to query API: ${response.statusCode}');
    }
  }
}