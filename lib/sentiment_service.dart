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
    var url = Uri.parse('http://192.168.1.241:5000/api/model-1'); // Change URL as needed
    var response = await http.post(url,
        body: jsonEncode({'inputs': text}), // Encode the body as JSON
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // Decode the response body
      var responseBody = jsonDecode(response.body);

      // The response is a list containing a single list of maps
      // So, we need to extract the inner list
      var nestedList = responseBody[0] as List;

    if (nestedList.isEmpty) {
      throw Exception('Nested list is null or empty');
    }
      // Now, you can pass this nestedList to your firstUntilPercentage method
      double targetPercentage = 0.95;
      List<Map<String, dynamic>> firstThree = firstUntilPercentage(nestedList, targetPercentage);
      return firstThree;
    } else {
      throw Exception('Failed to query API: ${response.statusCode}');
    }
  }

}