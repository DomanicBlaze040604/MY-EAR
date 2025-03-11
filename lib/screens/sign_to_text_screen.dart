import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

class SignToTextScreen extends StatefulWidget {
  const SignToTextScreen({super.key});

  @override
  _SignToTextScreenState createState() => _SignToTextScreenState();
}

class _SignToTextScreenState extends State<SignToTextScreen> {
  late CameraController _controller;
  bool _isDetecting = false;
  String _detectedSign = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTflite();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _initializeTflite() async {
    await Tflite.loadModel(model: "assets/model.tflite");
  }

  void _startDetection() {
    setState(() {
      _isDetecting = true;
    });
    _detectSign();
  }

  void _stopDetection() {
    setState(() {
      _isDetecting = false;
    });
  }

  Future<void> _detectSign() async {
    if (!_isDetecting) return;
    var recognitions = await Tflite.runModelOnFrame(
      bytesList:
          _controller.value.previewFrame!.image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
      imageHeight: _controller.value.previewFrame!.image.height,
      imageWidth: _controller.value.previewFrame!.image.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 1,
      threshold: 0.1,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      setState(() {
        _detectedSign = recognitions.first['label'];
      });
    }

    if (_isDetecting) {
      Future.delayed(const Duration(milliseconds: 100), _detectSign);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Sign to Text')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
          const SizedBox(height: 20),
          Text(
            'Detected Sign: $_detectedSign',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isDetecting ? _stopDetection : _startDetection,
            child: Text(_isDetecting ? 'Stop Detection' : 'Start Detection'),
          ),
        ],
      ),
    );
  }
}
