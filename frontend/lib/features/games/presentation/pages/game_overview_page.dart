import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/games/data/datasources/game_remote_datasource.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:basketvibe/core/utils/snackbars/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Single game overview page where users can see details and join.
class GameOverviewPage extends StatelessWidget {
  const GameOverviewPage({
    super.key,
    this.gameId,
  });

  final String? gameId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GameCubit>()..watchActiveGames(),
      child: _GameOverviewView(gameId: gameId),
    );
  }
}

class _GameOverviewView extends StatelessWidget {
  const _GameOverviewView({this.gameId});

  final String? gameId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Game Overview')),
      body: BlocConsumer<GameCubit, GameState>(
        listener: (context, state) {
          if (state is GameError) {
            AppSnackbar.error(context, state.message);
          } else if (state is GameActionSuccess) {
            AppSnackbar.success(context, state.message);
          } else if (state is GameCancelled) {
            AppSnackbar.success(context, 'Game cancelled');
          }
        },
        builder: (context, state) {
          if (state is GameLoading || state is GameInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = state is GameLoaded
              ? state.games
              : state is GameActionSuccess
                  ? state.games
                  : const <GameEntity>[];
          if (games.isEmpty) {
            return Center(
              child: Padding(
                padding: AppSpacing.pagePadding,
                child: Text(
                  'No active games available right now.',
                  style: AppTextStyles.bodyMD.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final selectedGame = gameId == null
              ? games.first
              : games.firstWhere(
                  (g) => g.id == gameId,
                  orElse: () => games.first,
                );

          final uid = getIt<FirebaseAuth>().currentUser?.uid;
          final isHost = uid != null && uid == selectedGame.hostId;

          return ListView(
            padding: AppSpacing.pagePadding,
            children: [
              _GameOverviewCard(game: selectedGame),
              AppSpacing.gapLG,
              // Host doesn't join/leave their own game.
              if (isHost)
                const SizedBox.shrink()
              else if (selectedGame.playerIds.contains(uid))
                ElevatedButton.icon(
                  onPressed: () {
                    if (uid == null) return;
                    context
                        .read<GameCubit>()
                        .leaveGame(selectedGame.id, uid);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.exit_to_app_rounded),
                  label: Text(AppLocalizations.of(context).gamesLeave),
                )
              else
                ElevatedButton.icon(
                  onPressed: selectedGame.isJoinable
                      ? () {
                          if (uid == null) {
                            AppSnackbar.error(
                              context,
                              AppLocalizations.of(context)
                                  .joinGameLoginMessage,
                            );
                            return;
                          }
                          context
                              .read<GameCubit>()
                              .joinGame(selectedGame.id, uid);
                        }
                      : null,
                  icon: const Icon(Icons.sports_basketball_rounded),
                  label: Text(
                    selectedGame.isJoinable
                        ? AppLocalizations.of(context).gamesJoin
                        : AppLocalizations.of(context).gamesFull,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _GameOverviewCard extends StatelessWidget {
  const _GameOverviewCard({required this.game});

  final GameEntity game;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateText = DateFormat('dd MMM, HH:mm').format(game.startTime);
    final teamSize = '${game.currentPlayers}/${game.maxPlayers}';
    final payment = game.pricePerPlayer == null
        ? 'Free'
        : 'Cash ${game.pricePerPlayer!.toStringAsFixed(0)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.brLG,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            game.title ?? game.courtName,
            style: AppTextStyles.h3.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.gapSM,
          if (game.description != null)
            Text(
              game.description!,
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          if (game.description != null) AppSpacing.gapSM,
          _InfoRow(label: 'Location', value: game.address, isDark: isDark),
          _InfoRow(label: 'Court', value: game.courtName, isDark: isDark),
          _InfoRow(label: 'Date & Time', value: dateText, isDark: isDark),
          _InfoRow(label: 'Team Size', value: teamSize, isDark: isDark),
          _HostNameTile(
            hostId: game.hostId,
            fallback: game.hostName,
            isDark: isDark,
          ),
          _InfoRow(label: 'Payment', value: payment, isDark: isDark),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              '$label:',
              style: AppTextStyles.labelSM.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows the host's display name, resolved live from the `users`
/// collection so it stays accurate even if the game's stored
/// [GameEntity.hostName] is stale.
class _HostNameTile extends StatefulWidget {
  const _HostNameTile({
    required this.hostId,
    required this.fallback,
    required this.isDark,
  });

  final String hostId;
  final String fallback;
  final bool isDark;

  @override
  State<_HostNameTile> createState() => _HostNameTileState();
}

class _HostNameTileState extends State<_HostNameTile> {
  late final Future<String?> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<GameRemoteDataSource>().getHostDisplayName(widget.hostId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _future,
      builder: (context, snapshot) {
        final name = snapshot.data ?? widget.fallback;
        return _InfoRow(label: 'Host', value: name, isDark: widget.isDark);
      },
    );
  }
}

