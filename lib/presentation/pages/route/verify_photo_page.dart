import 'dart:typed_data';

import 'package:bydgoszcz/core/network/openai_service.dart';
import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/di/injector.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class VerifyPhotoPage extends StatefulWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;

  const VerifyPhotoPage({
    super.key,
    required this.route,
    required this.stop,
    required this.monument,
  });

  @override
  State<VerifyPhotoPage> createState() => _VerifyPhotoPageState();
}

class _VerifyPhotoPageState extends State<VerifyPhotoPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isVerifying = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
      );

      if (photo != null) {
        final bytes = await photo.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Nie udało się zrobić zdjęcia';
      });
    }
  }

  Future<void> _verifyPhoto() async {
    if (_imageBytes == null) return;

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final openAiService = getIt.get<OpenAiService>();
      final result = await openAiService.verifyLocationPhoto(
        imageBytes: _imageBytes!,
        expectedMonumentName: widget.monument.name,
        expectedMonumentFacts: widget.monument.facts,
      );

      if (!mounted) return;

      final isCorrect = result['isCorrectLocation'] as bool;
      final explanation = result['explanation'] as String;

      if (isCorrect) {
        // Success - go to quiz
        context.pushReplacement(
          '/route/${widget.route.id}/stop/${widget.stop.id}/quiz',
          extra: {
            'route': widget.route,
            'stop': widget.stop,
            'monument': widget.monument,
          },
        );
      } else {
        // Not correct location
        setState(() {
          _isVerifying = false;
          _errorMessage = explanation;
        });
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _errorMessage = 'Wystąpił błąd podczas weryfikacji. Spróbuj ponownie.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.soft,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Weryfikacja zdjęciem',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bydgoszczBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.bydgoszczBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_rounded,
                      color: AppColors.bydgoszczBlue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Zrób zdjęcie ${widget.stop.name}, żeby potwierdzić, że tam jesteś!',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.bydgoszczBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Photo area
              Expanded(
                child: _imageBytes != null
                    ? _buildPhotoPreview()
                    : _buildPhotoPlaceholder(),
              ),

              const SizedBox(height: 24),

              // Error message
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Buttons
              if (_imageBytes == null)
                Column(
                  children: [
                    _buildActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Zrób zdjęcie',
                      color: AppColors.bydgoszczBlue,
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Wybierz z galerii',
                      color: AppColors.bydgoszczYellow,
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                )
              else if (_isVerifying)
                _buildLoadingButton()
              else
                Column(
                  children: [
                    _buildActionButton(
                      icon: Icons.check_rounded,
                      label: 'Sprawdź zdjęcie',
                      color: AppColors.success,
                      onTap: _verifyPhoto,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text(
                        'Zrób nowe zdjęcie',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.bydgoszczBlue,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textDisabled.withOpacity(0.3),
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_rounded,
              size: 64,
              color: AppColors.textDisabled.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Brak zdjęcia',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kliknij przycisk poniżej',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(_imageBytes!, fit: BoxFit.cover),
          if (_isVerifying)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sprawdzam zdjęcie...',
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textDisabled,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Weryfikuję...',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
