import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class LocalDiseaseClassifier {
  static const String modelPath = 'assets/models/plant_disease.tflite';
  static const String labelsPath = 'assets/models/labels.json';

  Interpreter? _interpreter;
  Map<String, dynamic>? _labels;

  Future<void> initialize() async {
    // Load model
    _interpreter = await Interpreter.fromAsset(modelPath);
    // Load labels
    final labelsData = await rootBundle.loadString(labelsPath);
    _labels = json.decode(labelsData);
  }

  Future<Map<String, dynamic>> classify(Uint8List imageBytes) async {
    if (_interpreter == null || _labels == null) {
      throw Exception('Classifier not initialized');
    }

    // Decode image
    img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) {
      throw Exception('Failed to decode image');
    }

    // Resize to 256x256
    img.Image resizedImage = img.copyResize(decodedImage, width: 256, height: 256);

    // Prepare input tensor [1, 256, 256, 3] float32
    var input = List.generate(1, (i) => List.generate(256, (y) => List.generate(256, (x) => List.filled(3, 0.0))));

    // ImageNet mean and std
    final mean = [0.485, 0.456, 0.406];
    final std = [0.229, 0.224, 0.225];

    for (int y = 0; y < 256; y++) {
      for (int x = 0; x < 256; x++) {
        final pixel = resizedImage.getPixel(x, y);
        // normalized to 0-1
        final r = pixel.r / 255.0;
        final g = pixel.g / 255.0;
        final b = pixel.b / 255.0;

        input[0][y][x][0] = (r - mean[0]) / std[0];
        input[0][y][x][1] = (g - mean[1]) / std[1];
        input[0][y][x][2] = (b - mean[2]) / std[2];
      }
    }

    // Prepare output tensor [1, 38]
    var output = List.generate(1, (i) => List.filled(38, 0.0));

    // Run inference
    _interpreter!.run(input, output);

    final probs = output[0];

    // Softmax
    double maxVal = probs.reduce((curr, next) => curr > next ? curr : next);
    double sum = 0.0;
    for (int i = 0; i < probs.length; i++) {
      probs[i] = (probs[i] - maxVal);
      probs[i] = (probs[i] < -20) ? 0.0 : (probs[i] * 2.718281828459045); // approximate exp
      sum += probs[i];
    }
    for (int i = 0; i < probs.length; i++) {
      probs[i] /= sum;
    }

    // Find top class
    int topIdx = 0;
    double topConf = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > topConf) {
        topIdx = i;
        topConf = probs[i];
      }
    }

    // OOD rejection: If confidence is lower than a strict threshold, reject it.
    if (topConf < 0.85) {
       return {
          "predicted_class": "Unrecognized Image",
          "crop": "Unknown",
          "condition": "Not a Plant or Unclear",
          "confidence": topConf,
          "is_healthy": false,
          "advice_hint": "We couldn't clearly identify a crop leaf in this image. Please ensure you are taking a close-up, well-lit photo of a single plant leaf.",
       };
    }

    final topMeta = _labels![topIdx.toString()] ?? {};

    return {
      "predicted_class": topMeta["display_name"] ?? "Unknown",
      "crop": topMeta["crop"] ?? "Unknown",
      "condition": topMeta["condition"] ?? "Unknown",
      "confidence": topConf,
      "is_healthy": topMeta["is_healthy"] == true,
      "advice_hint": topMeta["advice_hint"] ?? "",
    };
  }
}
