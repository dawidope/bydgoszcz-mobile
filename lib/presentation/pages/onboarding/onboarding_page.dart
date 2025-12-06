import 'package:bydgoszcz/core/constants/app_constants.dart';
import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/models/user_profile.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final Set<String> _selectedInterests = {};

  // Mapowanie zainteresowań na ikony i kolory
  static const Map<String, IconData> _interestIcons = {
    'Smoki i fantastyka': Icons.auto_awesome,
    'Historia i zamki': Icons.castle,
    'Muzyka i sztuka': Icons.palette,
    'Przyroda i parki': Icons.park,
    'Wojsko i technika': Icons.precision_manufacturing,
  };

  static const List<Color> _interestColors = [
    AppColors.bydgoszczRed,
    AppColors.bydgoszczYellow,
    AppColors.bydgoszczBlue,
    AppColors.success,
    AppColors.bydgoszczRed,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() {
    if (_formKey.currentState!.validate() && _selectedInterests.isNotEmpty) {
      final profile = UserProfile(
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 10,
        interests: _selectedInterests.toList(),
      );

      context.read<AppCubit>().completeOnboarding(profile);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Header
                _buildHeader(),

                const SizedBox(height: 40),

                // Imię field
                _buildNameField(),

                const SizedBox(height: 24),

                // Wiek field
                _buildAgeField(),

                const SizedBox(height: 32),

                // Zainteresowania section
                _buildInterestsSection(),

                const SizedBox(height: 32),

                // Error message
                if (_selectedInterests.isEmpty) _buildErrorMessage(),

                // Submit button
                _buildSubmitButton(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kolorowe domki jako dekoracja
        Row(
          children: [
            _buildMiniHouse(AppColors.bydgoszczRed, 24),
            const SizedBox(width: 8),
            _buildMiniHouse(AppColors.bydgoszczYellow, 32),
            const SizedBox(width: 8),
            _buildMiniHouse(AppColors.bydgoszczBlue, 20),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Opowiedz nam\no sobie!',
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Dzięki temu dopasujemy historie do Ciebie',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniHouse(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline, color: AppColors.bydgoszczRed, size: 20),
            const SizedBox(width: 8),
            Text(
              'Jak masz na imię?',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.soft,
          ),
          child: TextFormField(
            controller: _nameController,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Twoje imię',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textDisabled,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Podaj swoje imię';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.cake_outlined,
              color: AppColors.bydgoszczYellow,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Ile masz lat?',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.soft,
          ),
          child: TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: 'Twój wiek',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textDisabled,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Podaj swój wiek';
              }
              final age = int.tryParse(value.trim());
              if (age == null || age < 1 || age > 120) {
                return 'Podaj poprawny wiek';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.interests_outlined,
              color: AppColors.bydgoszczBlue,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Co Cię interesuje?',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Wybierz przynajmniej jedno',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppConstants.availableInterests.asMap().entries.map((
            entry,
          ) {
            final index = entry.key;
            final interest = entry.value;
            final isSelected = _selectedInterests.contains(interest);
            final color = _interestColors[index % _interestColors.length];
            final icon = _interestIcons[interest] ?? Icons.star;

            return _buildInterestChip(
              interest: interest,
              icon: icon,
              color: color,
              isSelected: isSelected,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInterestChip({
    required String interest,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedInterests.remove(interest);
          } else {
            _selectedInterests.add(interest);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.textDisabled.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.soft,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : color),
            const SizedBox(width: 8),
            Text(
              interest,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.error, size: 20),
            const SizedBox(width: 8),
            Text(
              'Wybierz przynajmniej jedno zainteresowanie',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return PrimaryButton(
      label: 'Gotowe!',
      icon: Icons.check_rounded,
      onPressed: _completeOnboarding,
    );
  }
}
