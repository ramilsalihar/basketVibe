import 'package:flutter/material.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';

/// The Baseline — TikTok-style highlights with "Dap" (fist-bump) instead of Like.
class BaselineFeedSection extends StatelessWidget {
  const BaselineFeedSection({super.key});

  static const List<Map<String, dynamic>> _mockClips = [
    {'title': 'Local Legends · Восток-5', 'daps': 124},
    {'title': 'Court Vibes · Спартак', 'daps': 89},
    {'title': 'Король вечера', 'daps': 256},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.pagePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Базовая линия',
                style: AppTextStyles.h2.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Всё',
                  style: AppTextStyles.labelMD.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _mockClips.length,
            itemBuilder: (context, index) {
              final clip = _mockClips[index];
              return _BaselineClipCard(
                title: clip['title'] as String,
                daps: clip['daps'] as int,
                isDark: isDark,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BaselineClipCard extends StatefulWidget {
  const _BaselineClipCard({
    required this.title,
    required this.daps,
    required this.isDark,
  });

  final String title;
  final int daps;
  final bool isDark;

  @override
  State<_BaselineClipCard> createState() => _BaselineClipCardState();
}

class _BaselineClipCardState extends State<_BaselineClipCard> {
  bool _dapped = false;
  int _dapCount = 0;

  @override
  void initState() {
    super.initState();
    _dapCount = widget.daps;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
        borderRadius: AppRadius.brMD,
        border: Border.all(
          color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Stack(
        children: [
          // Placeholder thumbnail
          Center(
            child: Icon(
              Icons.videocam_outlined,
              size: 48,
              color: widget.isDark
                  ? AppColors.darkTextMuted
                  : AppColors.lightTextMuted,
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.labelSM.copyWith(
                    color: widget.isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _dapped = !_dapped;
                      _dapCount += _dapped ? 1 : -1;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        _dapped ? Icons.front_hand : Icons.front_hand_outlined,
                        size: 20,
                        color: _dapped ? AppColors.primary : (widget.isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$_dapCount',
                        style: AppTextStyles.labelSM.copyWith(
                          color: widget.isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
