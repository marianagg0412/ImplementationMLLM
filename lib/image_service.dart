import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageService {
  Future<List<Map<String, dynamic>>?> analyzeImage(Uint8List imageData, String fileName) async {
<<<<<<< Updated upstream
    var uri = Uri.parse('http://192.168.1.241:5000/api/model-2');
=======
    var uri = Uri.parse('http://192.168.1.2:5000/api/model-2');
>>>>>>> Stashed changes
    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageData,
      filename: fileName,
      contentType: MediaType('image', 'jpeg'),
    ));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      List<dynamic> jsonResponse = jsonDecode(responseData);  
      return firstUntilPercentage(jsonResponse, 0.80); // Assuming a target percentage of 90%
    } else {
      print(response.statusCode);
      return null;
    }
  }

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
      if(contribution > 0.20) {
        currentPercentage += contribution;
        resultList.add(elementMap);
      }
    }
    return resultList;
  }
}
