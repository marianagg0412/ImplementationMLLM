import 'dart:convert';
import 'package:http/http.dart' as http;

class SentimentService {
  List<Map<String, dynamic>> firstUntilPercentage(List<dynamic> nestedList, double targetPercentage) {
    double currentPercentage = 0.0;
    List<Map<String, dynamic>> resultList = [];

      for (var element in nestedList) {
        while(currentPercentage <= targetPercentage) {
          Map<String, dynamic> elementMap = element as Map<String, dynamic>;
          double contribution = elementMap['score'];
          currentPercentage += contribution;
          resultList.add(elementMap);
      }
    }
    return resultList;
  }


  Future<List<Map<String, dynamic>>> querySentiment(String text) async {
    var url = Uri.parse('http://127.0.0.1:5000/api/model-1'); //change url
    var response = await http.post(url,
        body: jsonEncode({'inputs': text}), // Encode the body as JSON
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      double targetPercentage = 0.90;
      var nestedList = list[0] as List;
      print(nestedList);
      List<Map<String, dynamic>> firstThree =
      firstUntilPercentage(nestedList, targetPercentage);
      print(firstThree);
      return firstThree;
    } else {
      throw Exception('Failed to query API: ${response.statusCode}');
    }
  }
}