import 'package:camera/camera.dart';

class SignLanguageCameraProvider {
  CameraController? _controller;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras available');
    }

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;
  CameraController? get controller => _controller;

  Future<void> startImageStream(Function(CameraImage) onImage) async {
    if (!_isInitialized) throw Exception('Camera not initialized');
    await _controller!.startImageStream(onImage);
  }

  Future<void> stopImageStream() async {
    if (!_isInitialized) return;
    await _controller!.stopImageStream();
  }

  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }
}
