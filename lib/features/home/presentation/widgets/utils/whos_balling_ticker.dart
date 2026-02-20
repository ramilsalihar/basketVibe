import 'dart:async';
import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';

/// FOMO ticker: "12 players just checked into Vostok-5... 3 spots left at Bishkek Arena 19:00"
class WhosBallingTicker extends StatefulWidget {
  const WhosBallingTicker({
    super.key,
    this.messages = const [
      '12 игроков зачекинились на Восток-5... 3 места на 5v5 в Бишкек Арена в 19:00',
      'Новый ран в 18:30 на Спартак — 4/10 мест',
      'Восток-5 сейчас горячая точка — 8 человек на площадке',
    ],
  });

  final List<String> messages;

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
              widget.messages.isEmpty ? '' : widget.messages[_index],
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
