import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import '../services/photo_classifier_service.dart';
import '../widgets/photo_result_dialog.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final _classifier = PhotoClassifierService();
  bool _isProcessing = false;
  bool _isDownloadingModel = false;

  Future<void> _takePhoto() async {
    final strings = context.read<LocaleProvider>().strings;

    final XFile? picked;
    try {
      picked = await ImagePicker().pickImage(source: ImageSource.camera);
    } catch (_) {
      _showMessage(strings.genericError);
      return;
    }
    if (picked == null) return;

    setState(() => _isProcessing = true);

    try {
      final result = await _classifier.classify(
        File(picked.path),
        onDownloadingModel: () {
          if (mounted) setState(() => _isDownloadingModel = true);
        },
      );
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isDownloadingModel = false;
      });

      if (result == null) {
        _showMessage(strings.photoNoMatch);
      } else {
        showPhotoResultDialog(context, result);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isDownloadingModel = false;
      });
      _showMessage(strings.genericError);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.watch<LocaleProvider>().strings;

    return Scaffold(
      appBar: AppBar(title: Text(strings.appTitle)),
      body: Center(
        child: _isProcessing
            ? _LoadingIndicator(
                message: _isDownloadingModel ? strings.downloadingModel : strings.processingPhoto,
              )
            : _CaptureButton(
          instructions: strings.photoInstructions,
          buttonLabel: strings.takePhoto,
          onPressed: _takePhoto,
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(message),
      ],
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({
    required this.instructions,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String instructions;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.camera_alt_outlined, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(instructions, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.camera_alt),
            label: Text(buttonLabel),
          ),
        ],
      ),
    );
  }
}
