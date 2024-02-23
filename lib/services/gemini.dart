import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:studybuddyhub/firebase/firestore.dart';

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

  Future getQuestionGemini(String text) async {
    try {
      await initializeGemini();
      final model =
          GenerativeModel(model: 'gemini-1.0-pro', apiKey: googleGeminiApiKey);
      final prompt = TextPart(text +
          "=> Bu metni analiz et ve bana soru hazırla.Sadece soruları gönder. ");
      final response = await model.generateContent([Content.text(prompt.text)]);
      String? cevap = response.text;
      List<String> soruListesi = cevap!
          .split('\n')
          .where((soru) => soru.isNotEmpty)
          .map((soru) => soru.split('. ').sublist(1).join('. '))
          .toList();

      List<Map<String, dynamic>> soruMapList = [];
      for (int i = 0; i < soruListesi.length; i++) {
        soruMapList.add({'soru': soruListesi[i]});
      }
      FirestoreMethods().setExamProfileFirestore(soruMapList);
    } catch (e) {
      print("Error generating content: $e");
      return null;
    }
  }

  Future<String?> geminImageAndTextPrompt(
      String userPrompt, String imagePath) async {
    try {
      await initializeGemini();
      final model =
          GenerativeModel(model: 'gemini-1.0-pro', apiKey: googleGeminiApiKey);
      final prompt = TextPart(userPrompt);
      final image = await File(imagePath).readAsBytes();

      final imageParts = [DataPart('image/jpeg', image)];
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      print(response.text);
      return response.text;
    } catch (e) {
      print("Error generating content: $e");
      return null;
    }
  }
}
