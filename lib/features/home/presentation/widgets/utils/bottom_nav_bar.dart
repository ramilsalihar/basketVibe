import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

/// Minimalist bottom navigation: no shadows, clean bar, smooth feel.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final selectedColor = AppColors.primary;
    final unselectedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Главная',
                isSelected: currentIndex == 0,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.event_rounded,
                label: 'События',
                isSelected: currentIndex == 1,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.sports_basketball_rounded,
                label: 'Площадки',
                isSelected: currentIndex == 2,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.person_rounded,
                label: 'Профиль',
                isSelected: currentIndex == 3,
                selectedColor: selectedColor,
                unselectedColor: unselectedColor,
                onTap: () => onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  static const double _iconSize = 22;
  static const double _labelSize = 11;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: selectedColor.withValues(alpha: 0.12),
        highlightColor: selectedColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                child: Icon(
                  icon,
                  size: _iconSize,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                style: AppTextStyles.labelSM.copyWith(
                  fontSize: _labelSize,
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
