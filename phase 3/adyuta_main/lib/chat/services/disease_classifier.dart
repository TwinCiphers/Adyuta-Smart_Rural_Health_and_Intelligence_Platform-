import 'dart:convert';
import 'package:flutter/services.dart';

// NOTE: tflite_flutter and image are intentionally NOT added as dependencies
// of adyuta_main to keep the integration lightweight. The LocalDiseaseClassifier
// is available in the standalone adyuta-chat app where those packages are present.
// In the integrated build, the classifier API is preserved but inference is stubbed.

class LocalDiseaseClassifier {
  static const String modelPath = 'assets/models/plant_disease.tflite';
  static const String labelsPath = 'assets/models/labels.json';

  Map<String, dynamic>? _labels;

  Future<void> initialize() async {
    // Load labels (model inference is stubbed in integrated build)
    final labelsData = await rootBundle.loadString(labelsPath);
    _labels = json.decode(labelsData);
  }

  Future<Map<String, dynamic>> classify(Uint8List imageBytes) async {
    if (_labels == null) {
      throw Exception('Classifier not initialized');
    }

    // tflite_flutter is not a dependency in the integrated adyuta_main build.
    // Return a stub response indicating model is unavailable.
    return {
      'predicted_class': 'Model Unavailable',
      'crop': 'Unknown',
      'condition': 'Standalone build required for on-device inference',
      'confidence': 0.0,
      'is_healthy': false,
      'advice_hint':
          'Please use the standalone adyuta-chat app for on-device plant disease classification.',
    };
  }
}
