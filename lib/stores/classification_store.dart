import 'package:mobx/mobx.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

part 'classification_store.g.dart';

class ClassificationStore = _ClassificationStore with _$ClassificationStore;

abstract class _ClassificationStore with Store {
  _ClassificationStore() {
    // loadModels();

    autorun((_) {
      print('auto run');
    });
  }

  @action
  Future<void> makeClassification(File image) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final ImageLabeler cloudLabeler = FirebaseVision.instance.cloudImageLabeler();
    final List<ImageLabel> cloudLabels = await cloudLabeler.processImage(visionImage);

    for (ImageLabel label in cloudLabels) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print('Text: $text - Entity: $entityId - Confidence: $confidence');
    }

    cloudLabeler.close();
  }
}
