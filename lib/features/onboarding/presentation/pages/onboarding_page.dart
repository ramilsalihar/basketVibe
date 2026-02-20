import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:basketvibe/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:basketvibe/features/onboarding/presentation/models/onboarding_content_data.dart';
import 'package:basketvibe/features/onboarding/presentation/widgets/onboarding_content.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContentData> _pages = [
    const OnboardingContentData(
      title: 'Найди площадку',
      description: 'Открой карту и найди ближайшие баскетбольные площадки в твоем городе',
      icon: Icons.location_on,
    ),
    const OnboardingContentData(
      title: 'Создай игру',
      description: 'Организуй свой "Ран" — пригласи игроков и собери команду',
      icon: Icons.sports_basketball,
    ),
    const OnboardingContentData(
      title: 'Делись моментами',
      description: 'Публикуй лучшие моменты в "Базовой линии" и вдохновляй других',
      icon: Icons.video_library,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onComplete();
    }
  }

  void _onComplete() {
    context.read<OnboardingBloc>().add(const CompleteOnboarding());
  }

  void _onSkip() {
    _onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(RouteConstants.login);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: AppSpacing.pagePadding,
                  child: TextButton(
                    onPressed: _onSkip,
                    child: Text(
                      'Пропустить',
                      style: AppTextStyles.labelLG.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return OnboardingContent(data: _pages[index]);
                  },
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted),
                      borderRadius: AppRadius.brPill,
                    ),
                  ),
                ),
              ),

              AppSpacing.gapXL,

              // Next/Get Started button
              Padding(
                padding: AppSpacing.pagePadding,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Начать'
                          : 'Далее',
                      style: AppTextStyles.buttonLG,
                    ),
                  ),
                ),
              ),

              AppSpacing.gapXL,
            ],
          ),
        ),
      ),
    );
  }
}
