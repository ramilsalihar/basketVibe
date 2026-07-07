import 'dart:async';
import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';

class WhosBallingTicker extends StatefulWidget {
  const WhosBallingTicker({
    super.key,
    this.messages = const [],
  });

  final List<String> messages;

  static List<String> defaultMessages(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      l10n.tickerMessage1,
      l10n.tickerMessage2,
      l10n.tickerMessage3,
    ];
  }

  @override
  State<WhosBallingTicker> createState() => _WhosBallingTickerState();
}

class _WhosBallingTickerState extends State<WhosBallingTicker> {
  late ScrollController _controller;
  late Timer _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || widget.messages.isEmpty) return;
      _index = (_index + 1) % widget.messages.length;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final messages = widget.messages.isEmpty
        ? WhosBallingTicker.defaultMessages(context)
        : widget.messages;

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface2
            : AppColors.primaryMuted.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.sports_basketball,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              messages.isEmpty ? '' : messages[_index],
              style: AppTextStyles.bodySM.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

