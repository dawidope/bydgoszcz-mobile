import 'dart:io';

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/presentation/bloc/monument_recognition_cubit.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd przy wybieraniu zdjęcia: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _recognizeMonument() {
    if (_selectedImage != null) {
      context.read<MonumentRecognitionCubit>().recognizeMonument(
        _selectedImage!.path,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonumentRecognitionCubit, MonumentRecognitionState>(
      listener: (context, state) {
        if (state is MonumentRecognitionSuccess) {
          // Nawiguj do szczegółów zabytku, przekazując obiekt Monument
          // Używamy push zamiast go, żeby pop() działał
          context.push(
            '/monuments/detail/${state.monument.id}',
            extra: state.monument,
          );
        } else if (state is MonumentRecognitionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      child: Scaffold(
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<MonumentRecognitionCubit, MonumentRecognitionState>(
          builder: (context, state) {
            // Fullscreen loader
            if (state is MonumentRecognitionLoading) {
              return _buildLoader();
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(),

                    const SizedBox(height: 32),

                    // Image preview or placeholder
                    Expanded(
                      child: _selectedImage == null
                          ? _buildPlaceholder()
                          : _buildImagePreview(),
                    ),

                    const SizedBox(height: 24),

                    // Action buttons
                    if (_selectedImage == null) ...[
                      _buildActionButtons(),
                    ] else ...[
                      _buildCheckButton(),
                      const SizedBox(height: 12),
                      _buildRetakeButton(),
                    ],

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bydgoszczBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.bydgoszczBlue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rozpoznaj zabytek',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _selectedImage == null
                        ? 'Zrób lub wybierz zdjęcie'
                        : 'Sprawdź, co znalazłeś!',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bydgoszczBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                size: 64,
                color: AppColors.bydgoszczBlue.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Dodaj zdjęcie zabytku',
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Zrób zdjęcie aparatem lub wybierz z galerii',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(_selectedImage!.path), fit: BoxFit.cover),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
              ),
            ),
          ),
          // Success badge
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(12),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Gotowe',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          label: 'Zrób zdjęcie',
          icon: Icons.camera_alt_rounded,
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        const SizedBox(height: 12),
        SecondaryButton(
          label: 'Wgraj z galerii',
          icon: Icons.photo_library_rounded,
          color: AppColors.bydgoszczBlue,
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildCheckButton() {
    return PrimaryButton(
      label: 'Sprawdź',
      icon: Icons.search_rounded,
      onPressed: _recognizeMonument,
    );
  }

  Widget _buildRetakeButton() {
    return SecondaryButton(
      label: 'Zmień zdjęcie',
      icon: Icons.refresh_rounded,
      color: AppColors.textSecondary,
      onPressed: () {
        setState(() {
          _selectedImage = null;
        });
      },
    );
  }

  Widget _buildLoader() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppColors.bydgoszczGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bydgoszczBlue.withOpacity(0.3),
                    blurRadius: 24,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: 24),
            Text(
              'Rozpoznaję zabytek...',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'To może potrwać chwilę',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
