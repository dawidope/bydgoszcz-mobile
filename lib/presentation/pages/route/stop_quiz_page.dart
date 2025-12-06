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
  bool _answered = false;
  bool _isCorrect = false;

  void _selectAnswer(int index) {
    if (_answered) return;

    final quiz = widget.stop.quiz;

    setState(() {
      _selectedAnswerIndex = index;
      _answered = true;
      _isCorrect = index == quiz.correctAnswerIndex;
    });

    // Mark stop as visited and quiz completed
    _markStopCompleted();
  }

  void _markStopCompleted() {
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
  }

  void _continue() {
    // Go back to route adventure page
    context.go('/route/adventure/${widget.route.id}');
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

              // Result and continue button
              if (_answered) _buildResult(),

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
    final showResult = _answered;

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData? icon;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = AppColors.success.withOpacity(0.1);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        icon = Icons.check_circle_rounded;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.error.withOpacity(0.1);
        borderColor = AppColors.error;
        textColor = AppColors.error;
        icon = Icons.cancel_rounded;
      } else {
        backgroundColor = AppColors.surfaceVariant;
        borderColor = AppColors.textDisabled.withOpacity(0.3);
        textColor = AppColors.textDisabled;
        icon = null;
      }
    } else {
      backgroundColor = isSelected
          ? AppColors.bydgoszczBlue.withOpacity(0.1)
          : AppColors.surfaceVariant;
      borderColor = isSelected
          ? AppColors.bydgoszczBlue
          : AppColors.textDisabled.withOpacity(0.3);
      textColor = isSelected ? AppColors.bydgoszczBlue : AppColors.textPrimary;
      icon = null;
    }

    return GestureDetector(
      onTap: () => _selectAnswer(index),
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

  Widget _buildResult() {
    return Column(
      children: [
        // Result message
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isCorrect
                ? AppColors.success.withOpacity(0.1)
                : AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isCorrect
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.accent.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                _isCorrect
                    ? Icons.emoji_events_rounded
                    : Icons.lightbulb_rounded,
                color: _isCorrect ? AppColors.success : AppColors.accent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isCorrect ? 'Świetnie! 🎉' : 'Prawie!',
                      style: AppTypography.titleMedium.copyWith(
                        color: _isCorrect
                            ? AppColors.success
                            : AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isCorrect
                          ? 'Poprawna odpowiedź! Zdobywasz punkty!'
                          : 'Następnym razem będzie lepiej!',
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

        // Continue button
        _buildContinueButton(),
      ],
    );
  }

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _continue,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              'Kontynuuj przygodę',
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
