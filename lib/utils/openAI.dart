import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:mingel_business/domain/events/module/event_failure.dart';
import 'package:mingel_business/main.dart';
import 'package:mingel_business/utils/image.dart';

class OpenAIService {
  final String _apiKey = env.openAIKey;
  final String _baseUrl = "https://api.openai.com/v1";

  Future<Either<EventFailure, bool>> checkExplicitContent(String text,
      {String? imagePath}) async {
    // Convert image to base64 if a path is provided
    String? imageBase64;
    if (imagePath != null && imagePath.isNotEmpty) {
      final compressedImage = await createThumbnailUsingCompress(
        originalPath: imagePath,
        thumbnailSize: 200,
        quality: 40,
      );

      if (compressedImage != null) {
        final bytes = await compressedImage.readAsBytes();
        imageBase64 = base64Encode(bytes);
      } else {
        throw Exception("Failed to compress image");
      }
    }

    // Build the messages payload
    final List<Map<String, dynamic>> messages = [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": "Analyze the following content for explicit, harmful, or inappropriate material. "
                "The language of content most probably is English or Croatian. "
                "Dont flag the content if people have revealing clothing. "
                "E.g. a bikini is not explicit, but a sexual act is. "
                "If such content is detected, return 'true', otherwise, respond with 'false'.",
          },
          {"type": "text", "text": text},
          if (imageBase64 != null)
            {
              "type": "image_url",
              "image_url": {"url": "data:image/jpeg;base64,$imageBase64"},
            },
        ],
      },
    ];

    // Build the request body
    final Map<String, dynamic> body = {
      "model": "gpt-4o-mini", // Ensure the model supports vision inputs
      "messages": messages,
      "temperature": 0.0,
      "max_tokens": 300,
    };
    try {
      // Send the request to OpenAI API
      final response = await http.post(
        Uri.parse("$_baseUrl/chat/completions"),
        headers: <String, String>{
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      // Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'].toLowerCase();
        if (content.contains("true")) {
          return left(const EventFailure.explicitContent());
        } else {
          return right(false);
        }
      } else {
        return left(
            const EventFailure.serverError(error: 'Failed to analyze content'));
      }
    } catch (e) {
      return left(const EventFailure.internetConnection());
    }
  }
}
