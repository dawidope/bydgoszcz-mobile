import 'dart:ui';

import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/repository/monuments_repository.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/presentation/bloc/app_cubit.dart';
import 'package:bydgoszcz/presentation/bloc/route_planning_cubit.dart';
import 'package:bydgoszcz/presentation/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoutePlanningPage extends StatefulWidget {
  const RoutePlanningPage({super.key});

  @override
  State<RoutePlanningPage> createState() => _RoutePlanningPageState();
}

class _RoutePlanningPageState extends State<RoutePlanningPage>
    with SingleTickerProviderStateMixin {
  final MonumentsRepository _repository = MonumentsRepository();
  final Set<String> _selectedMonumentIds = {};
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool get _isSelectionValid =>
      _selectedMonumentIds.length >= 2 && _selectedMonumentIds.length <= 5;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMonumentSelection(String monumentId) {
    setState(() {
      if (_selectedMonumentIds.contains(monumentId)) {
        _selectedMonumentIds.remove(monumentId);
      } else {
        if (_selectedMonumentIds.length < 5) {
          _selectedMonumentIds.add(monumentId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Możesz wybrać maksymalnie 5 zabytków'),
              backgroundColor: AppColors.warning,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  void _generateRoute() {
    if (_isSelectionValid) {
      final userProfile = context.read<AppCubit>().state.userProfile;
      if (userProfile != null) {
        context.read<RoutePlanningCubit>().generateRoute(
          selectedMonumentIds: _selectedMonumentIds.toList(),
          userProfile: userProfile,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final monuments = _repository.getAllMonuments();

    return BlocConsumer<RoutePlanningCubit, RoutePlanningState>(
      listener: (context, state) {
        if (state is RoutePlanningSuccess) {
          // TODO: Navigate to route details page
          context.go('/route/adventure/${state.route.id}');
        } else if (state is RoutePlanningError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Main content
              _buildMainContent(monuments),

              // Loading overlay with blur
              if (state is RoutePlanningGenerating)
                _buildLoadingOverlay(state.statusMessage),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(List<Monument> monuments) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: _buildHeader(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildInfoCard(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: monuments.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final monument = monuments[index];
                  final isSelected = _selectedMonumentIds.contains(monument.id);

                  return _MonumentSelectCard(
                    monument: monument,
                    isSelected: isSelected,
                    onTap: () => _toggleMonumentSelection(monument.id),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: _buildActionButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay(String message) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.bydgoszczBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Magic sparkles animation
                _buildMagicSparkles(),

                const SizedBox(height: 24),

                // Status message
                Text(
                  message,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'To może chwilę potrwać...',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Progress indicator
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMagicSparkles() {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 200)),
            builder: (context, value, child) {
              return Opacity(
                opacity: (value * 2 > 1) ? (2 - value * 2) : value * 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.star_rounded,
                    size: 16 + (index % 2) * 8,
                    color: [
                      AppColors.bydgoszczYellow,
                      AppColors.primary,
                      AppColors.bydgoszczBlue,
                      AppColors.accent,
                      AppColors.bydgoszczYellow,
                    ][index],
                  ),
                ),
              );
            },
          );
        }),
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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.route_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Zaplanuj trasę',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Wybierz miejsca do odwiedzenia',
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bydgoszczYellow.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.bydgoszczYellow.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bydgoszczYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wybierz od 2 do 5 zabytków',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Wybrano: ${_selectedMonumentIds.length} / 5',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return PrimaryButton(
      label: _isSelectionValid
          ? 'Stwórz przygodę ✨'
          : 'Wybierz zabytki (min. 2)',
      onPressed: _isSelectionValid ? _generateRoute : null,
      icon: Icons.auto_awesome_rounded,
    );
  }
}

class _MonumentSelectCard extends StatelessWidget {
  final Monument monument;
  final bool isSelected;
  final VoidCallback onTap;

  const _MonumentSelectCard({
    required this.monument,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textDisabled.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : AppShadows.card,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Monument Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(monument.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Monument Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      monument.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monument.shortDescription,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Selection Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.check_rounded : Icons.add_rounded,
                  color: isSelected ? Colors.white : AppColors.textDisabled,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
