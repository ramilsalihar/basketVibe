import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:basketvibe/features/auth/presentation/cubit/auth_state.dart';
import 'package:basketvibe/features/games/domain/entities/game_entity.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_cubit.dart';
import 'package:basketvibe/features/games/presentation/cubit/game_state.dart';

/// Court option for dropdown (matches mock courts from map/court finder).
class _CourtOption {
  const _CourtOption({required this.id, required this.name, this.address});
  final String id;
  final String name;
  final String? address;
}

enum _PaymentOption { online, cash, free }

/// Host a game — create a new game lobby ("The Run").
class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  static const List<_CourtOption> _courts = [
    _CourtOption(id: 'court_1', name: 'Восток-5', address: 'Улица · Бесплатно'),
    _CourtOption(id: 'court_2', name: 'Спартак', address: 'Зал · Платно'),
    _CourtOption(id: 'court_3', name: 'Бишкек Арена', address: 'Зал · Платно'),
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxPlayersController = TextEditingController(text: '10');
  final _cashAmountController = TextEditingController();

  _CourtOption? _selectedCourt;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  _PaymentOption _paymentOption = _PaymentOption.free;
  int _maxPlayers = 10;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

  void _submitForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCourt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите площадку')),
      );
      return;
    }

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите дату и время')),
      );
      return;
    }

    double? pricePerPlayer;
    if (_paymentOption == _PaymentOption.cash) {
      final amount = double.tryParse(_cashAmountController.text.trim());
      if (amount == null || amount < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Введите корректную сумму')),
        );
        return;
      }
      pricePerPlayer = amount;
    }

    final hostId = context.read<AuthCubit>().state is AuthAuthenticated
        ? 'user_1'
        : 'guest_1';
    final hostName = 'Вы';

    final startTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final game = GameEntity(
      id: '',
      courtId: _selectedCourt!.id,
      courtName: _selectedCourt!.name,
      city: 'Бишкек',
      address: _selectedCourt!.address ?? _selectedCourt!.name,
      hostId: hostId,
      hostName: hostName,
      startTime: startTime,
      duration: const Duration(hours: 2),
      maxPlayers: _maxPlayers,
      currentPlayers: 1,
      visibility: GameVisibility.public,
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

    return BlocListener<GameCubit, GameState>(
      listener: (context, state) {
        if (state is GameCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Ран создан успешно!'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is GameError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
        appBar: AppBar(
          title: const Text('Host a game'),
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
                        labelText: 'Title *',
                        hintText: 'e.g. Evening Run, 3x3 Tournament',
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      style: AppTextStyles.bodyMD,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a title';
                        }
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,
                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'e.g. 3x3, intermediate, bring dark tee',
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      style: AppTextStyles.bodyMD,
                      maxLines: 3,
                    ),
                    AppSpacing.gapMD,
                    // Court dropdown
                    DropdownButtonFormField<_CourtOption>(
                      value: _selectedCourt,
                      decoration: InputDecoration(
                        labelText: 'Court *',
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      hint: const Text('Choose a court'),
                      items: _courts
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCourt = value),
                      validator: (value) {
                        if (value == null) return 'Choose a court';
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
                                          ? 'Date *'
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
                                          ? 'Time *'
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
                        labelText: 'Max players *',
                        hintText: '10',
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.brMD,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.bodyMD,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter number of players';
                        }
                        final players = int.tryParse(value);
                        if (players == null || players < 2 || players > 20) {
                          return 'Between 2 and 20';
                        }
                        _maxPlayers = players;
                        return null;
                      },
                    ),
                    AppSpacing.gapMD,
                    // Payment options
                    Text(
                      'Payment',
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
                              ? 'Online'
                              : option == _PaymentOption.cash
                                  ? 'Cash'
                                  : 'Free',
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
                          'In development',
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
                            labelText: 'Amount to bring',
                            hintText: 'e.g. 500',
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
                              'Host game',
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
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
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
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
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
