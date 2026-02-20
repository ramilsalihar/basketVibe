import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/courts/data/map_service.dart';

/// Full-screen court finder with map, heatmap, and filters.
class CourtFinderPage extends StatefulWidget {
  const CourtFinderPage({super.key});

  @override
  State<CourtFinderPage> createState() => _CourtFinderPageState();
}

class _CourtFinderPageState extends State<CourtFinderPage> {
  final MapService _mapService = MapService();
  final MapController _mapController = MapController();
  List<Marker> _markers = [];
  bool _isLoadingLocation = false;

  final LatLng _initialCenter = MapService.defaultCenter;
  final double _initialZoom = MapService.defaultZoom;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Load mock court markers
    final markers = _mapService.getMockCourtMarkers();
    setState(() {
      _markers = markers;
    });

    // Try to get user location
    _isLoadingLocation = true;
    await _mapService.goToCurrentLocation(_mapController);
    if (mounted) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _centerOnUserLocation() async {
    await _mapService.goToCurrentLocation(_mapController);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
        children: [
          // Map
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialCenter,
                    initialZoom: _initialZoom,
                    maxZoom: 18.0,
                    minZoom: 5.0,
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
                if (_isLoadingLocation)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                // Location button overlay
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: _centerOnUserLocation,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    child: const Icon(Icons.my_location, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          // Filters and list
          Container(
            padding: AppSpacing.pagePadding,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Quick filters
                Row(
                  children: [
                    _FilterChip(label: 'Зал', isSelected: false),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Улица', isSelected: true),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Бесплатно', isSelected: false),
                  ],
                ),
                AppSpacing.gapXL,
                Text(
                  'Популярные площадки',
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                AppSpacing.gapMD,
                _CourtListTile(name: 'Восток-5', subtitle: 'Улица · Бесплатно'),
                _CourtListTile(name: 'Спартак', subtitle: 'Зал · Платно'),
                _CourtListTile(name: 'Бишкек Арена', subtitle: 'Зал · Платно'),
              ],
            ),
          ),
        ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected});

  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: AppColors.primaryMuted,
      checkmarkColor: AppColors.primary,
    );
  }
}

class _CourtListTile extends StatelessWidget {
  const _CourtListTile({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryMuted,
        child: const Icon(Icons.sports_basketball, color: AppColors.primary),
      ),
      title: Text(
        name,
        style: AppTextStyles.labelLG.copyWith(
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySM.copyWith(
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
