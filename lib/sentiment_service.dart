import 'dart:convert';
import 'package:http/http.dart' as http;

class SentimentService {

  List<Map<String, dynamic>> firstUntilPercentage(List<dynamic> nestedList, double targetPercentage) {
    double currentPercentage = 0.0;
    List<Map<String, dynamic>> resultList = [];
    for (var element in nestedList) {
      Map<String, dynamic> elementMap = element as Map<String, dynamic>;
      double contribution = elementMap['score'];
      if ((currentPercentage + contribution) > targetPercentage && resultList.isNotEmpty) {
        // If adding this element's score would exceed the target, skip adding it.
        continue;
      }
      if(contribution > 0.05) {
        currentPercentage += contribution;
        resultList.add(elementMap);
      }
    }
    return resultList;
  }



  Future<List<Map<String, dynamic>>> querySentiment(String text) async {
    var url = Uri.parse('http://192.168.1.7:5000/api/model-1'); //change url
    var response = await http.post(url,
        body: jsonEncode({'inputs': text}), // Encode the body as JSON
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // Decode the response body
      var responseBody = jsonDecode(response.body);

      print('Response body: $responseBody');

      // Check if the response body is null
      if (responseBody == null) {
        print('Response body is null, returning empty list');
        return [];
      }

      var nestedList = responseBody[0] as List;

      print('Nested list: $nestedList');

      // Check if the nested list is null or empty
      if (nestedList.isEmpty) {
        throw Exception('Nested list is null or empty');
      }

      double targetPercentage = 0.95;
      List<Map<String, dynamic>> firstThree = firstUntilPercentage(nestedList, targetPercentage);
      return firstThree;
    } else {
      throw Exception('Failed to query API: ${response.statusCode}');
    }
  }

}