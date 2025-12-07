import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:bydgoszcz/data/local/route_storage.dart';
import 'package:bydgoszcz/models/generated_route.dart';
import 'package:bydgoszcz/models/monument.dart';
import 'package:bydgoszcz/models/route_stop.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StopQuizPage extends StatefulWidget {
  final GeneratedRoute route;
  final RouteStop stop;
  final Monument monument;

  const StopQuizPage({
    super.key,
    required this.route,
    required this.stop,
    required this.monument,
  });

  @override
  State<StopQuizPage> createState() => _StopQuizPageState();
}

class _StopQuizPageState extends State<StopQuizPage> {
  int? _selectedAnswerIndex;
  int? _wrongAnswerIndex; // Track wrong answer for red highlight
  bool _isCorrect = false;
  bool _showingWrongFeedback = false;

  void _selectAnswer(int index) {
    if (_showingWrongFeedback) return; // Don't allow selection during feedback

    final quiz = widget.stop.quiz;
    final isCorrect = index == quiz.correctAnswerIndex;

    if (isCorrect) {
      setState(() {
        _selectedAnswerIndex = index;
        _isCorrect = true;
      });
      // Mark stop as completed only on correct answer
      _markStopCompleted();
    } else {
      // Wrong answer - show red feedback briefly, then allow retry
      setState(() {
        _wrongAnswerIndex = index;
        _showingWrongFeedback = true;
      });

      // Reset after 800ms to allow another try
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _wrongAnswerIndex = null;
            _showingWrongFeedback = false;
          });
        }
      });
    }
  }

  GeneratedRoute _markStopCompleted() {
    final routeStorage = RouteStorage();

    // Update the stop as visited
    final updatedStops = widget.route.stops.map((s) {
      if (s.id == widget.stop.id) {
        return s.copyWith(visited: true, quizCompleted: true);
      }
      return s;
    }).toList();

    // Check if all stops are visited
    final allVisited = updatedStops.every((s) => s.visited);

    // Update route
    final updatedRoute = widget.route.copyWith(
      stops: updatedStops,
      completed: allVisited,
    );

    routeStorage.saveRoute(updatedRoute);
    return updatedRoute;
  }

  void _claimReward() {
    // Get updated route with this stop marked as completed
    final updatedRoute = RouteStorage().getRoute(widget.route.id);
    if (updatedRoute == null) return;

    // Check if all stops are now completed
    final allStopsCompleted = updatedRoute.stops.every((s) => s.visited);

    // Navigate to seal reward page
    context.pushReplacement(
      '/route/${widget.route.id}/stop/${widget.stop.id}/reward',
      extra: {
        'route': updatedRoute,
        'stop': widget.stop,
        'monument': widget.monument,
        'allStopsCompleted': allStopsCompleted,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.stop.quiz;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              // Congratulations header
              _buildCongratulations(),

              const SizedBox(height: 32),

              // Quiz section
              _buildQuizSection(quiz),

              const SizedBox(height: 32),

              // Result and claim reward button
              if (_isCorrect) _buildSuccessResult(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongratulations() {
    return Column(
      children: [
        // Success icon with animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  size: 56,
                  color: AppColors.success,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),

        Text(
          'Gratulacje! 🎉',
          style: AppTypography.headlineLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Jesteś przy ${widget.stop.name}!',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Odpowiedz na pytanie, żeby zdobyć punkty!',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuizSection(quiz) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bydgoszczBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: AppColors.bydgoszczBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quiz',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question
          Text(
            quiz.question,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Answers
          ...List.generate(quiz.answers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAnswerOption(
                index: index,
                answer: quiz.answers[index],
                isCorrect: index == quiz.correctAnswerIndex,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnswerOption({
    required int index,
    required String answer,
    required bool isCorrect,
  }) {
    final isSelected = _selectedAnswerIndex == index;
    final isWrongSelected = _wrongAnswerIndex == index;
    final hasCorrectAnswer = _isCorrect;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (hasCorrectAnswer && isCorrect) {
      // Show correct answer in green
      backgroundColor = AppColors.success.withOpacity(0.1);
      borderColor = AppColors.success;
      textColor = AppColors.success;
      icon = Icons.check_circle_rounded;
    } else if (isWrongSelected) {
      // Show wrong selection in red temporarily
      backgroundColor = AppColors.error.withOpacity(0.1);
      borderColor = AppColors.error;
      textColor = AppColors.error;
      icon = Icons.cancel_rounded;
    } else if (hasCorrectAnswer) {
      // Dim other options when correct answer is found
      backgroundColor = AppColors.surfaceVariant;
      borderColor = AppColors.textDisabled.withOpacity(0.3);
      textColor = AppColors.textDisabled;
      icon = null;
    } else {
      // Normal state - not answered yet
      backgroundColor = AppColors.surfaceVariant;
      borderColor = AppColors.textDisabled.withOpacity(0.3);
      textColor = AppColors.textPrimary;
      icon = null;
    }

    return GestureDetector(
      onTap: hasCorrectAnswer ? null : () => _selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon != null
                    ? Icon(icon, color: textColor, size: 20)
                    : Text(
                        String.fromCharCode(65 + index), // A, B, C, D
                        style: AppTypography.titleSmall.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                answer,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessResult() {
    return Column(
      children: [
        // Success message
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: AppColors.success,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Świetnie! 🎉',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Poprawna odpowiedź! Odbierz swoją nagrodę!',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Claim reward button
        _buildClaimRewardButton(),
      ],
    );
  }

  Widget _buildClaimRewardButton() {
    return GestureDetector(
      onTap: _claimReward,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.accent.withRed(200)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.stars_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Odbierz nagrodę! 🏆',
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
}
