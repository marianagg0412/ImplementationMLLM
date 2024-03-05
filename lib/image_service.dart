import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageService {
  Future<Map<String, dynamic>?> analyzeImage(String imagePath) async {
    // Replace 'http://your-api-url' with the actual URL of your image analysis API
    var url = Uri.parse('http://your-api-url');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to analyze image: ${response.statusCode}');
    }
  }
}
