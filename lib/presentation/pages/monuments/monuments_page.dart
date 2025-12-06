import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/presentation/widgets/cards/action_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MonumentsPage extends StatelessWidget {
  const MonumentsPage({super.key});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 40),

              // Options
              _buildOptions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dekoracja - kolorowe kwadraty
        Row(
          children: [
            Container(
              width: 8,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bydgoszczRed,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.bydgoszczYellow,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 16,
              decoration: BoxDecoration(
                color: AppColors.bydgoszczBlue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Jak chcesz poznać\nzabytek?',
          style: AppTypography.displaySmall.copyWith(
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Wybierz sposób, który Ci najbardziej odpowiada',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Column(
      children: [
        ActionCard.primary(
          title: 'Wybierz z listy',
          subtitle: 'Przeglądaj wszystkie zabytki Bydgoszczy',
          icon: Icons.list_alt_rounded,
          onTap: () {
            context.push('/monuments/list');
          },
        ),
        const SizedBox(height: 16),
        ActionCard.secondary(
          title: 'Zrób zdjęcie',
          subtitle: 'Rozpoznaj zabytek aparatem',
          icon: Icons.camera_alt_rounded,
          onTap: () {
            context.push('/monuments/camera');
          },
        ),
        const SizedBox(height: 16),
        ActionCard.light(
          title: 'Dodaj opis',
          subtitle: 'Opisz miejsce, które widzisz',
          icon: Icons.edit_note_rounded,
          accentColor: AppColors.bydgoszczYellow,
          onTap: () {
            // TODO: Navigate to manual description
          },
        ),
      ],
    );
  }
}
