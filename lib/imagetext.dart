import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ImportGallery extends StatefulWidget {
  const ImportGallery({super.key});

  @override
  State<ImportGallery> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<ImportGallery> {
  late TextRecognizer _textRecognizer;
  final FlutterTts _flutterTts = FlutterTts();

  String _recognizedText = "";
  String _currentLanguage = "en-US";
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_currentLanguage);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setVolume(_volume);
  }

  void _toggleLanguage() async {
    setState(() {
      _currentLanguage = _currentLanguage == "en-US" ? "ar-SA" : "en-US";
    });
    await _flutterTts.setLanguage(_currentLanguage);
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final inputImage = InputImage.fromFilePath(pickedFile.path);

      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      final newText = recognizedText.text.trim();

      if (newText.isNotEmpty) {
        setState(() {
          _recognizedText = newText;
        });

        _speakText(newText);
      }
    }
  }

  Future<void> _speakText(String text) async {
    final processedText = _processTextForNaturalSpeech(text);
    await _flutterTts.stop();
    await Future.delayed(const Duration(milliseconds: 200));
    await _flutterTts.speak(processedText);
  }

  String _processTextForNaturalSpeech(String text) {
    var processed = text;
    processed = processed.replaceAll(' and ', ', and ');
    processed = processed.replaceAll(' but ', ', but ');
    processed = processed.replaceAll(' or ', ', or ');
    processed = processed.replaceAll('%', ' percent ');
    processed = processed.replaceAll('&', ' and ');
    processed = processed.replaceAll('+', ' plus ');
    processed = processed.replaceAll('=', ' equals ');
    processed = processed.replaceAll('/', ' divided by ');
    return processed;
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📸 Image Text Recognition"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
            tooltip: "Language: $_currentLanguage",
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: const Text('Pick an image from gallery'),
            ),
            const SizedBox(height: 20),
            Text(
              _recognizedText.isEmpty
                  ? "No text recognized"
                  : _recognizedText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}