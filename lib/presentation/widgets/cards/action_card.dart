import 'package:bydgoszcz/core/theme/app_colors.dart';
import 'package:bydgoszcz/core/theme/app_shadows.dart';
import 'package:bydgoszcz/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Karta akcji - główny element nawigacyjny na ekranie głównym
/// Może mieć ikonę, tytuł, opcjonalny opis i gradient tła
class ActionCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double? height;
  final bool showArrow;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.gradient,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.height,
    this.showArrow = true,
  });

  /// Wariant z gradientem primary (pomarańczowy)
  factory ActionCard.primary({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    double? height,
    bool showArrow = true,
  }) {
    return ActionCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      gradient: AppColors.primaryGradient,
      iconColor: Colors.white,
      textColor: Colors.white,
      height: height,
      showArrow: showArrow,
    );
  }

  /// Wariant z gradientem secondary (turkusowy)
  factory ActionCard.secondary({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    double? height,
    bool showArrow = true,
  }) {
    return ActionCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      gradient: AppColors.secondaryGradient,
      iconColor: Colors.white,
      textColor: Colors.white,
      height: height,
      showArrow: showArrow,
    );
  }

  /// Wariant z jasnym tłem
  factory ActionCard.light({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color accentColor = AppColors.primary,
    double? height,
    bool showArrow = true,
  }) {
    return ActionCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      backgroundColor: AppColors.surface,
      iconColor: accentColor,
      textColor: AppColors.textPrimary,
      height: height,
      showArrow: showArrow,
    );
  }

  @override
  State<ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final hasGradient = widget.gradient != null;
    final iconColor = widget.iconColor ?? AppColors.primary;
    final textColor = widget.textColor ?? AppColors.textPrimary;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.height,
          decoration: BoxDecoration(
            gradient: hasGradient ? widget.gradient : null,
            color: hasGradient
                ? null
                : widget.backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isPressed
                ? (hasGradient ? AppShadows.primaryGlow(0.3) : AppShadows.soft)
                : (hasGradient ? AppShadows.primary : AppShadows.card),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: hasGradient
                          ? Colors.white.withOpacity(0.2)
                          : iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(width: 16),
                  // Text content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTypography.titleLarge.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: AppTypography.bodySmall.copyWith(
                              color: textColor.withOpacity(0.8),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Arrow
                  if (widget.showArrow)
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: textColor.withOpacity(0.6),
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mała karta akcji (kwadratowa) dla siatki
class ActionCardSmall extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;

  const ActionCardSmall({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color = AppColors.primary,
  });

  @override
  State<ActionCardSmall> createState() => _ActionCardSmallState();
}

class _ActionCardSmallState extends State<ActionCardSmall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      _controller.reverse();
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isPressed ? AppShadows.soft : AppShadows.card,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
