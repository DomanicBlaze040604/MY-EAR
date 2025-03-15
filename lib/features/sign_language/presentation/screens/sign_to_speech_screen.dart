
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

class SignToSpeechScreen extends StatefulWidget {
  const SignToSpeechScreen({super.key});

  @override
  _SignToSpeechScreenState createState() => _SignToSpeechScreenState();
}

class _SignToSpeechScreenState extends State<SignToSpeechScreen> {
  late CameraController _controller;
  late FlutterTts _flutterTts;
  bool _isDetecting = false;
  String _detectedSign = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTflite();
    _flutterTts = FlutterTts();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras.first, ResolutionPreset.medium);
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _initializeTflite() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
    );
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
      bytesList: _controller.value.previewFrame!.image.planes.map((plane) {
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
