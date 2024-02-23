import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:studybuddyhub/services/gemini.dart';

class OCR {
  final Gemini _gemini = Gemini();
  Future<String> getImageToText(String imagePath) async {
    try {
      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
      String text = recognizedText.text.toString();
      _gemini.getQuestionGemini(text);
      return text;
    } catch (e) {
      print("Error processing image: $e");
      return ""; // Hata durumunda boş bir string döndür
    }
  }
}
