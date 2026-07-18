import 'dart:io';

import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

/// Classifies a photo on-device (English label) and translates it to
/// Spanish, also on-device. Returns null if no confident label was found.
class PhotoClassifierService {
  final _modelManager = OnDeviceTranslatorModelManager();

  Future<String?> classify(File image, {void Function()? onDownloadingModel}) async {
    final label = await _topLabel(image);
    if (label == null) return null;

    await _ensureModelsDownloaded(onDownloadingModel);
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

  /// The translation models aren't bundled in the app — they download on
  /// first use. The library defaults to requiring Wi-Fi for that download,
  /// which silently fails (and throws) on mobile data. Downloading them
  /// explicitly with isWifiRequired: false avoids that.
  Future<void> _ensureModelsDownloaded(void Function()? onDownloading) async {
    final englishReady = await _modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    final spanishReady = await _modelManager.isModelDownloaded(TranslateLanguage.spanish.bcpCode);
    if (englishReady && spanishReady) return;

    onDownloading?.call();
    if (!englishReady) {
      await _modelManager.downloadModel(TranslateLanguage.english.bcpCode, isWifiRequired: false);
    }
    if (!spanishReady) {
      await _modelManager.downloadModel(TranslateLanguage.spanish.bcpCode, isWifiRequired: false);
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
