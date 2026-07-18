import 'dart:io';

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Classifies a photo on-device (English label) and translates it to
/// Spanish, also on-device. Returns null if no confident label was found.
class PhotoClassifierService {
  Future<String?> classify(File image) async {
    final label = await _topLabel(image);
    if (label == null) return null;
    return _translateToSpanish(label);
  }

  Future<String?> _topLabel(File image) async {
    final labeler = ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
    try {
      final labels = await labeler.processImage(InputImage.fromFilePath(image.path));
      if (labels.isEmpty) return null;
      return labels.first.label;
    } finally {
      await labeler.close();
    }
  }

  Future<String> _translateToSpanish(String englishLabel) async {
    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.spanish,
    );
    try {
      return await translator.translateText(englishLabel);
    } finally {
      await translator.close();
    }
  }
}
