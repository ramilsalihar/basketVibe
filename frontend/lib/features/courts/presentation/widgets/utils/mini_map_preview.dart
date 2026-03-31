import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/features/courts/data/map_service.dart';

/// Mini map preview for home feed. Tappable to open full Court Finder.
class MiniMapPreview extends StatefulWidget {
  const MiniMapPreview({
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  State<MiniMapPreview> createState() => _MiniMapPreviewState();
}

class _MiniMapPreviewState extends State<MiniMapPreview> {
  final MapService _mapService = MapService();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    final markers = _mapService.getMockCourtMarkers();
    setState(() {
      _markers = markers;
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: AppRadius.brMD,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.brMD,
          child: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: MapService.defaultCenter,
                  initialZoom: MapService.defaultZoom,
                  maxZoom: 18.0,
                  minZoom: 5.0,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png',
                    userAgentPackageName: 'com.basketvibe.app',
                    maxZoom: 19,
                  ),
                  MarkerLayer(markers: _markers),
                ],
              ),
              // Overlay gradient for better text visibility
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              // Filter chips overlay
              Positioned(
                top: 8,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    _MiniChip(label: 'Зал'),
                    const SizedBox(width: 6),
                    _MiniChip(label: 'Улица'),
                    const SizedBox(width: 6),
                    _MiniChip(label: 'Бесплатно'),
                  ],
                ),
              ),
              // CTA overlay
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppRadius.brPill,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Открыть карту',
                        style: AppTextStyles.labelSM.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface3 : AppColors.lightSurface2,
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSM.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}
