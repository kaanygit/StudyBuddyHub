import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Gemini {
  late String googleGeminiApiKey;

  Future<void> initializeGemini() async {
    await dotenv.load();
    googleGeminiApiKey = await getApiKey();
  }

  Future<String> getApiKey() async {
    String? apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      return "null";
    }
    return apiKey;
  }

  Future<String?> geminiTextPrompt(String userPrompt) async {
    try {
      await initializeGemini(); // googleGeminiApiKey'yi başlatmak için
      final model =
          GenerativeModel(model: 'gemini-1.0-pro', apiKey: googleGeminiApiKey);
      final prompt = TextPart(userPrompt);
      final response = await model.generateContent([Content.text(prompt.text)]);
      print(response.text);
      return response.text;
    } catch (e) {
      print("Error generating content: $e");
      return null;
    }
  }
}
