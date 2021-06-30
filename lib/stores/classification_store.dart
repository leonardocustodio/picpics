import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ClassificationStore {
  /* ClassificationStore() {
    // loadModels();
  } */

  Future<void> makeClassification(File image) async {
    final visionImage = FirebaseVisionImage.fromFile(image);
    final cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final cloudLabels = await cloudLabeler.processImage(visionImage);

    for (var label in cloudLabels) {
      final text = label.text;
      final entityId = label.entityId;
      final confidence = label.confidence;
      //print('Text: $text - Entity: $entityId - Confidence: $confidence');
    }

    cloudLabeler.close();
  }
}
