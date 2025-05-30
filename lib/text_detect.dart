import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({super.key});

  @override
  State<TextRecognitionScreen> createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  CameraController? _cameraController;
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
    _initializeCamera();
    _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_currentLanguage);
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setVolume(_volume);

    try {
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        final naturalVoices = voices.where((voice) {
          final voiceMap = voice as Map<String, dynamic>;
          final voiceName = voiceMap['name'] as String? ?? '';
          return voiceName.toLowerCase().contains('natural') ||
              voiceName.toLowerCase().contains('enhanced') ||
              voiceName.toLowerCase().contains('premium');
        }).toList();

        if (naturalVoices.isNotEmpty) {
          final selectedVoice = naturalVoices.first as Map<String, dynamic>;
          await _flutterTts.setVoice({
            "name": selectedVoice["name"],
            "locale": selectedVoice["locale"]
          });
        }
      }
    } catch (e) {
      print("Error setting voice: $e");
    }
  }

  void _toggleLanguage() async {
    setState(() {
      _currentLanguage = (_currentLanguage == "en-US") ? "ar-SA" : "en-US";
    });
    await _flutterTts.setLanguage(_currentLanguage);
  }

  Future<void> _initializeCamera() async {
    await Permission.camera.request();
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _captureAndRecognizeText() async {
    if (!_cameraController!.value.isInitialized) return;

    try {
      final imageFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      final text = recognizedText.text.trim();

      if (text.isNotEmpty) {
        setState(() {
          _recognizedText = text;
        });
        await _speakText(text);
      }
    } catch (e) {
      print("Error taking picture: $e");
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
    _cameraController?.dispose();
    _textRecognizer.close();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("📸 Text Recognition"),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
            tooltip: "Language: $_currentLanguage",
          ),
          IconButton(
            icon: const Icon(Icons.settings_voice),
            onPressed: _showVoiceSettings,
            tooltip: "Voice Settings",
          ),
        ],
      ),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black54,
                  child: Text(
                    _recognizedText,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _captureAndRecognizeText,
                  icon: const Icon(Icons.camera),
                  label: const Text("Take Picture"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Voice Settings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text("Speech Rate: ${_speechRate.toStringAsFixed(1)}"),
                  Slider(
                    value: _speechRate,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    onChanged: (value) {
                      setModalState(() => _speechRate = value);
                      _flutterTts.setSpeechRate(value);
                    },
                  ),
                  Text("Pitch: ${_pitch.toStringAsFixed(1)}"),
                  Slider(
                    value: _pitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    onChanged: (value) {
                      setModalState(() => _pitch = value);
                      _flutterTts.setPitch(value);
                    },
                  ),
                  Text("Volume: ${_volume.toStringAsFixed(1)}"),
                  Slider(
                    value: _volume,
                    min: 0.1,
                    max: 1.0,
                    divisions: 9,
                    onChanged: (value) {
                      setModalState(() => _volume = value);
                      _flutterTts.setVolume(value);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _speakText("This is a test of the voice settings.");
                    },
                    child: const Text("Test Voice"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}