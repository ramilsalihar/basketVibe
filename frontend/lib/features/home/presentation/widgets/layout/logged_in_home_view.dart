import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:basketvibe/core/constants/route_constants.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';
import 'package:basketvibe/features/auth/presentation/widgets/auth_lock_view.dart';
import 'package:basketvibe/features/courts/presentation/pages/court_finder_page.dart';
import 'package:basketvibe/features/games/presentation/pages/upcoming_games_page.dart';
import 'package:basketvibe/features/home/presentation/pages/home_feed_page.dart';
import 'package:basketvibe/features/home/presentation/widgets/navigation/bottom_nav_bar.dart';
import 'package:basketvibe/features/profile/presentation/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoggedInHomeView extends StatefulWidget {
  const LoggedInHomeView({super.key});

  @override
  State<LoggedInHomeView> createState() => _LoggedInHomeViewState();
}

class _LoggedInHomeViewState extends State<LoggedInHomeView> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentIndex = index),
        children: [
          HomeFeedPage(
            notificationCount: 2,
            onNavigateToCourts: () => _onTabTapped(2),
          ),
          const UpcomingGamesPage(),
          const CourtFinderPage(),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is! AuthAuthenticated) {
                return const AuthLockView(
                  message:
                      'Войдите, чтобы видеть профиль и историю игр.',
                );
              }
              return ProfilePage(
                userId: FirebaseAuth.instance.currentUser?.uid ?? '',
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                final authed =
                    context.read<AuthCubit>().state is AuthAuthenticated;
                if (!authed) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => Scaffold(
                        appBar: AppBar(),
                        body: const AuthLockView(
                          message: 'Войдите, чтобы создать игру.',
                        ),
                      ),
                    ),
                  );
                  return;
                }
                context.push(RouteConstants.createGame);
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              highlightElevation: 0,
              child: const Icon(Icons.add_rounded, size: 28),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

