import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:basketvibe/core/network/injection.dart';
import 'package:basketvibe/core/utils/snackbars/app_snackbar.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/auth/data/datasources/remote/user_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';

enum _PaymentOption { online, cash, free }

/// Host a game — create a new game lobby ("The Run").
class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _maxPlayersController = TextEditingController(text: '10');
  final _cashAmountController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  _PaymentOption _paymentOption = _PaymentOption.free;
  GameVisibility _visibility = GameVisibility.public;
  int _maxPlayers = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _maxPlayersController.dispose();
    _cashAmountController.dispose();
    super.dispose();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => _DatePickerSheet(
        initial: _selectedDate ?? now,
        minimumDate: now,
        maximumDate: now.add(const Duration(days: 365)),
        onDone: (DateTime value) {
          setState(() => _selectedDate = value);
        },
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    TimeOfDay picked = _selectedTime ?? TimeOfDay.now();
    final initial = DateTime(2000, 1, 1, picked.hour, picked.minute);

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => _TimePickerSheet(
        initial: initial,
        onDone: (TimeOfDay value) {
          setState(() => _selectedTime = value);
        },
      ),
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _selectedTime == null) {
      AppSnackbar.error(context, l10n.createGameSelectDateTime);
      return;
    }

    double? pricePerPlayer;
    if (_paymentOption == _PaymentOption.cash) {
      final amount = double.tryParse(_cashAmountController.text.trim());
      if (amount == null || amount < 0) {
        AppSnackbar.error(context, l10n.createGameInvalidAmount);
        return;
      }
      pricePerPlayer = amount;
    }

    final currentUser = getIt<FirebaseAuth>().currentUser;
    if (currentUser == null) {
      AppSnackbar.error(context, l10n.createGameLoginMessage);
      return;
    }
    final hostId = currentUser.uid;
    // Use the profile name from the `users` collection, not the Firebase
    // Auth displayName — the latter can be stale after a profile edit.
    final userDoc = await getIt<UserRemoteDataSource>().getUser(hostId);
    final hostName = (userDoc?['displayName'] as String?) ??
        currentUser.displayName ??
        l10n.createGameYou;

    final startTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final location = _locationController.text.trim();
    final game = GameEntity(
      id: '',
      courtId: '',
      courtName: location,
      city: '',
      address: location,
      hostId: hostId,
      hostName: hostName,
      startTime: startTime,
      duration: const Duration(hours: 2),
      maxPlayers: _maxPlayers,
      currentPlayers: 1,
      playerIds: [hostId],
      visibility: _visibility,
      level: GameLevel.balanced,
      status: GameStatus.open,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      pricePerPlayer: pricePerPlayer,
    );

    context.read<GameCubit>().createGame(game);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return BlocListener<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameCreated) {
          AppSnackbar.success(context, l10n.createGameSuccess);
          context.pop();
        } else if (state is GameError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(
          title: Text(l10n.createGameTitle),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ),
        body: BlocBuilder<GameCubit, GameState>(
          builder: (context, state) {
            final isLoading = state is GameLoading;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: AppSpacing.pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.gapLG,
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: l10n.createGameTitleLabel,
                        hintText: l10n.createGameTitleHint,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      style: AppTextStyles.bodyMD,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.createGameTitleError;
                        }
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.createGameDescription,
                        hintText: l10n.createGameDescriptionHint,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      style: AppTextStyles.bodyMD,
                      maxLines: 3,
                    ),
                    AppSpacing.gapMD,
                    // Location — paste a map link or address
                    TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: l10n.createGameLocationLabel,
                        hintText: l10n.createGameLocationHint,
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      style: AppTextStyles.bodyMD,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.createGameLocationError;
                        }
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,
                    // Date & Time
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _showDatePicker(context),
                            child: Container(
                              padding: AppSpacing.cardPadding,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                                borderRadius: AppRadius.brMD,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  AppSpacing.rowGapMD,
                                  Expanded(
                                    child: Text(
                                      _selectedDate == null
                                          ? l10n.createGameDate
                                          : DateFormat('dd.MM.yyyy')
                                              .format(_selectedDate!),
                                      style: AppTextStyles.bodyMD.copyWith(
                                        color: _selectedDate == null
                                            ? (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary)
                                            : (isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppSpacing.rowGapMD,
                        Expanded(
                          child: InkWell(
                            onTap: () => _showTimePicker(context),
                            child: Container(
                              padding: AppSpacing.cardPadding,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                                borderRadius: AppRadius.brMD,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: AppColors.primary,
                                  ),
                                  AppSpacing.rowGapMD,
                                  Expanded(
                                    child: Text(
                                      _selectedTime == null
                                          ? l10n.createGameTime
                                          : _selectedTime!.format(context),
                                      style: AppTextStyles.bodyMD.copyWith(
                                        color: _selectedTime == null
                                            ? (isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.lightTextSecondary)
                                            : (isDark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapMD,
                    // Max Players
                    TextFormField(
                      controller: _maxPlayersController,
                      decoration: InputDecoration(
                        labelText: l10n.createGameMaxPlayers,
                        hintText: '10',
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.bodyMD,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.createGameMaxPlayersError;
                        }
                        final players = int.tryParse(value);
                        if (players == null || players < 2 || players > 20) {
                          return l10n.createGameMaxPlayersRange;
                        }
                        _maxPlayers = players;
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,
                    // Visibility (public / private)
                    Text(
                      l10n.createGameVisibility,
                      style: AppTextStyles.labelMD.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    AppSpacing.gapSM,
                    SegmentedButton<GameVisibility>(
                      segments: [
                        ButtonSegment(
                          value: GameVisibility.public,
                          icon: const Icon(Icons.public_rounded, size: 18),
                          label: Text(l10n.visibilityPublic),
                        ),
                        ButtonSegment(
                          value: GameVisibility.private,
                          icon: const Icon(Icons.lock_outline_rounded, size: 18),
                          label: Text(l10n.visibilityPrivate),
                        ),
                      ],
                      selected: {_visibility},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) =>
                          setState(() => _visibility = s.first),
                    ),
                    AppSpacing.gapXS,
                    Text(
                      _visibility == GameVisibility.public
                          ? l10n.visibilityPublicHint
                          : l10n.visibilityPrivateHint,
                      style: AppTextStyles.bodySM.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    AppSpacing.gapMD,
                    // Payment options
                    Text(
                      l10n.createGamePayment,
                      style: AppTextStyles.labelMD.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    AppSpacing.gapSM,
                    ..._PaymentOption.values.map((option) {
                      return RadioListTile<_PaymentOption>(
                        title: Text(
                          option == _PaymentOption.online
                              ? l10n.paymentOnline
                              : option == _PaymentOption.cash
                                  ? l10n.paymentCash
                                  : l10n.paymentFree,
                        ),
                        value: option,
                        groupValue: _paymentOption,
                        onChanged: (value) =>
                            setState(() => _paymentOption = value!),
                        activeColor: AppColors.primary,
                      );
                    }),
                    if (_paymentOption == _PaymentOption.online) ...[
                      AppSpacing.gapSM,
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          l10n.inDevelopment,
                          style: AppTextStyles.bodySM.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                    if (_paymentOption == _PaymentOption.cash) ...[
                      AppSpacing.gapSM,
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: TextFormField(
                          controller: _cashAmountController,
                          decoration: InputDecoration(
                            labelText: l10n.createGameAmount,
                            hintText: l10n.createGameAmountHint,
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.brMD,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: AppTextStyles.bodyMD,
                        ),
                      ),
                    ],
                    AppSpacing.gapXL,
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              l10n.createGameSubmit,
                              style: AppTextStyles.buttonLG.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                    AppSpacing.gapXL,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DatePickerSheet extends StatefulWidget {
  const _DatePickerSheet({
    required this.initial,
    required this.minimumDate,
    required this.maximumDate,
    required this.onDone,
  });

  final DateTime initial;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final void Function(DateTime value) onDone;

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(AppLocalizations.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: Text(AppLocalizations.of(context).done),
                  onPressed: () {
                    widget.onDone(_picked);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: widget.initial,
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                onDateTimeChanged: (DateTime value) =>
                    setState(() => _picked = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({
    required this.initial,
    required this.onDone,
  });

  final DateTime initial;
  final void Function(TimeOfDay value) onDone;

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late DateTime _picked;

  @override
  void initState() {
    super.initState();
    _picked = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(AppLocalizations.of(context).cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: Text(AppLocalizations.of(context).done),
                  onPressed: () {
                    widget.onDone(
                        TimeOfDay(hour: _picked.hour, minute: _picked.minute));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: widget.initial,
                use24hFormat: true,
                onDateTimeChanged: (DateTime value) =>
                    setState(() => _picked = value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
