import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({Key? key}) : super(key: key);

  @override
  _ObjectDetectionScreenState createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen> with WidgetsBindingObserver {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  bool isDetecting = false;
  List<dynamic> recognitions = [];
  bool isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeCamera();
    loadModel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize the camera
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initializeCamera();
    }
  }

  Future<void> initializeCamera() async {
    try {
      // Get available cameras
      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        print('No cameras available');
        return;
      }

      // Use the first camera (usually the back camera)
      cameraController = CameraController(
        cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      // Initialize the camera
      await cameraController!.initialize();

      if (!mounted) return;

      setState(() {});

      // Start camera stream after setState to ensure UI is updated
      cameraController!.startImageStream((CameraImage image) {
        if (!isDetecting && isModelLoaded) {
          isDetecting = true;
          analyzeImage(image);
        }
      });

    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );

      setState(() {
        isModelLoaded = true;
        print("Model loaded successfully");
      });
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> analyzeImage(CameraImage image) async {
    try {
      // Use just the Y plane from YUV image
      var results = await Tflite.runModelOnFrame(
        bytesList: [image.planes[0].bytes],
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 5,
        threshold: 0.4,
        asynch: true,
      );

      if (mounted && results != null) {
        setState(() {
          // Format results to match our UI expectations
          recognitions = results.map((res) => {
            'rect': {'x': 0.1, 'y': 0.1, 'w': 0.8, 'h': 0.8}, // Default rect for classifications
            'detectedClass': res['label'] ?? 'unknown',
            'confidenceInClass': res['confidence'] ?? 0.0,
          }).toList();

          if (recognitions.isNotEmpty) {
            print("Detected: ${recognitions[0]['detectedClass']} - ${(recognitions[0]['confidenceInClass'] * 100).toStringAsFixed(0)}%");
          }
        });
      }
    } catch (e) {
      print('Error analyzing image: $e');
    } finally {
      isDetecting = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.stopImageStream();
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;

    // Calculate scale to fill the screen
    var scale = size.aspectRatio * cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full screen camera preview
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Center(
              child: CameraPreview(cameraController!),
            ),
          ),

          // Bounding boxes overlay
          _buildBoxesOverlay(size),

          // App bar overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.black54,
              elevation: 0,
              title: const Text('Object Detection'),
            ),
          ),

          // Detection info panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildDetectionInfoPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildBoxesOverlay(Size screenSize) {
    if (recognitions.isEmpty) return Container();

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: CustomPaint(
        painter: BoundingBoxPainter(
          recognitions: recognitions,
          screenSize: screenSize,
        ),
      ),
    );
  }

  Widget _buildDetectionInfoPanel() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.black54,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Detected Objects:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...recognitions.map((recognition) {
            return Text(
              '${recognition['detectedClass']} - ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            );
          }).toList(),
          if (recognitions.isEmpty)
            const Text(
              'No objects detected',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<dynamic> recognitions;
  final Size screenSize;

  final List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
  ];

  BoundingBoxPainter({
    required this.recognitions,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final Paint textBgPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.7);

    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    for (var i = 0; i < recognitions.length; i++) {
      final recognition = recognitions[i];

      // For MobileNet which does classification (not object detection),
      // we'll just show a centered box
      final rect = Rect.fromLTWH(
        recognition['rect']['x'] * screenSize.width,
        recognition['rect']['y'] * screenSize.height,
        recognition['rect']['w'] * screenSize.width,
        recognition['rect']['h'] * screenSize.height,
      );

      final colorIndex = i % colors.length;
      boxPaint.color = colors[colorIndex];

      canvas.drawRect(rect, boxPaint);

      final String label =
          '${recognition['detectedClass']} ${(recognition['confidenceInClass'] * 100).toStringAsFixed(0)}%';

      final textSpan = TextSpan(
        text: label,
        style: textStyle,
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final textBgRect = Rect.fromLTWH(
        rect.left,
        rect.top - textPainter.height - 4,
        textPainter.width + 8,
        textPainter.height + 4,
      );

      canvas.drawRect(textBgRect, textBgPaint);

      textPainter.paint(
        canvas,
        Offset(rect.left + 4, rect.top - textPainter.height),
      );
    }
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return recognitions != oldDelegate.recognitions;
  }
}