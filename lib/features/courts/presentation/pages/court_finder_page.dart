import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:basketvibe/core/widgets/dialogs/app_dialog.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
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

  static const List<_CourtOverviewData> _popularCourts = [
    _CourtOverviewData(
      name: 'Восток-5',
      address: '7-й микрорайон, 52/4',
      distanceMeters: 800,
      status: 'Открыто',
      statusColor: AppColors.success,
      schedule: '11:00 - 23:00',
      imageUrls: [
        'https://images.unsplash.com/photo-1519861531473-9200262188bf?w=600',
        'https://images.unsplash.com/photo-1461896836934-ffe607ba8211?w=600',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=600',
      ],
    ),
    _CourtOverviewData(
      name: 'Спартак',
      address: 'пр. Мира, 19',
      distanceMeters: 1200,
      status: 'Закрыто',
      statusColor: AppColors.accentPink,
      schedule: '10:00 - 22:00',
      imageUrls: [
        'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=600',
        'https://images.unsplash.com/photo-1505666287802-931dc83a5dc7?w=600',
        'https://images.unsplash.com/photo-1518063319789-7217e6706b04?w=600',
      ],
    ),
    _CourtOverviewData(
      name: 'Бишкек Арена',
      address: 'ул. Манаса, 88',
      distanceMeters: 1500,
      status: 'Открыто',
      statusColor: AppColors.success,
      schedule: '09:00 - 00:00',
      imageUrls: [
        'https://images.unsplash.com/photo-1471295253337-3ceaaedca402?w=600',
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=600',
        'https://images.unsplash.com/photo-1543357480-c60d40007a3f?w=600',
      ],
    ),
  ];

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

  void _showCourtOverview(_CourtOverviewData court) {
    AppDialog.showBottomSheet<void>(
      context: context,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      content: _SingleCourtOverview(court: court),
    );
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
                  bottom: 16,
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
                _CourtListTile(
                  name: 'Восток-5',
                  subtitle: 'Улица · Бесплатно',
                  onTap: () => _showCourtOverview(_popularCourts[0]),
                ),
                _CourtListTile(
                  name: 'Спартак',
                  subtitle: 'Зал · Платно',
                  onTap: () => _showCourtOverview(_popularCourts[1]),
                ),
                _CourtListTile(
                  name: 'Бишкек Арена',
                  subtitle: 'Зал · Платно',
                  onTap: () => _showCourtOverview(_popularCourts[2]),
                ),
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
  const _CourtListTile({
    required this.name,
    required this.subtitle,
    this.onTap,
  });

  final String name;
  final String subtitle;
  final VoidCallback? onTap;

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
      onTap: onTap,
    );
  }
}

class _CourtOverviewData {
  const _CourtOverviewData({
    required this.name,
    required this.address,
    required this.distanceMeters,
    required this.status,
    required this.statusColor,
    required this.schedule,
    required this.imageUrls,
  });

  final String name;
  final String address;
  final int distanceMeters;
  final String status;
  final Color statusColor;
  final String schedule;
  final List<String> imageUrls;
}

class _SingleCourtOverview extends StatelessWidget {
  const _SingleCourtOverview({required this.court});

  final _CourtOverviewData court;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: court.imageUrls.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => ClipRRect(
              borderRadius: AppRadius.brSM,
              child: Image.network(
                court.imageUrls[index],
                width: 110,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 100,
                  color: isDark ? AppColors.darkSurface2 : AppColors.lightSurface2,
                  child: const Icon(
                    Icons.image_not_supported_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        AppSpacing.gapLG,
        Text(
          '${court.name}, ${court.address}',
          style: AppTextStyles.h1.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        AppSpacing.gapMD,
        Row(
          children: [
            Icon(
              Icons.near_me_rounded,
              size: 16,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${court.distanceMeters} м',
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: court.statusColor.withOpacity(0.15),
                borderRadius: AppRadius.brPill,
              ),
              child: Text(
                court.status,
                style: AppTextStyles.labelMD.copyWith(color: court.statusColor),
              ),
            ),
          ],
        ),
        AppSpacing.gapLG,
        Row(
          children: [
            Text(
              'Время работы',
              style: AppTextStyles.bodyMD.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              court.schedule,
              style: AppTextStyles.labelLG.copyWith(
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        AppSpacing.gapLG,
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.primaryButtonGradient,
            borderRadius: AppRadius.brPill,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
            ),
            child: Text(
              'Бронировать',
              style: AppTextStyles.buttonLG.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
