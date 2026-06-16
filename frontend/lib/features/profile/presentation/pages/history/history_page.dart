import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Realtime list of games the current user hosts or has joined.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return BlocProvider(
      create: (_) => getIt<GameCubit>()..watchMyGames(uid),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          if (state is GameLoading || state is GameInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          final games =
              state is GameLoaded ? state.games : const <GameEntity>[];
          if (games.isEmpty) {
            return Center(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Text(
                  l10n.historyEmpty,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMD.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            padding: AppSpacing.pagePadding,
            itemCount: games.length,
            itemBuilder: (context, index) =>
                _HistoryTile(game: games[index], isDark: isDark),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.game, required this.isDark});

  final GameEntity game;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM, HH:mm').format(game.startTime);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.sports_basketball_rounded,
            color: AppColors.primary),
        title: Text(
          game.title ?? game.courtName,
          style: AppTextStyles.labelLG.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        subtitle: Text(
          '$date · ${game.courtName}',
          style: AppTextStyles.bodySM.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        trailing: Text(
          '${game.currentPlayers}/${game.maxPlayers}',
          style: AppTextStyles.labelMD.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
