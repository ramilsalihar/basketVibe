import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:basketvibe/core/widgets/dialogs/app_dialog.dart';
import 'package:basketvibe/core/styles/app_colors.dart';
import 'package:basketvibe/core/styles/app_border_radius.dart';
import 'package:basketvibe/core/styles/app_spacing.dart';
import 'package:basketvibe/core/styles/app_text_styles.dart';
import 'package:basketvibe/features/courts/data/models/court_model.dart';
import 'package:basketvibe/features/courts/data/models/sport_type_model.dart';
import 'package:basketvibe/features/courts/data/map_service.dart';
import 'package:basketvibe/features/courts/presentation/cubit/courts_cubit.dart';
import 'package:basketvibe/features/courts/presentation/cubit/courts_state.dart';
import 'package:basketvibe/core/l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

/// Full-screen court finder with map, heatmap, and filters.
/// Reads courts/sport types from the surrounding [CourtsCubit].
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

  // Filters. null = no filter applied.
  String? _sportFilter; // sportTypeId
  String? _typeFilter; // 'indoor' | 'outdoor'
  bool _freeOnly = false;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  List<CourtModel> _applyFilters(List<CourtModel> courts) {
    return courts.where((c) {
      if (_sportFilter != null && c.sportTypeId != _sportFilter) return false;
      if (_typeFilter != null && c.type != _typeFilter) return false;
      if (_freeOnly && !c.isFree) return false;
      return true;
    }).toList();
  }

  void _showCourtOverview(
    CourtModel court,
    Map<String, SportTypeModel> sportTypes,
  ) {
    AppDialog.showBottomSheet<void>(
      context: context,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      content: _SingleCourtOverview(
        court: court,
        sportType: sportTypes[court.sportTypeId],
      ),
    );
    if (court.lat != 0 || court.lng != 0) {
      try {
        _mapService.goToLocation(_mapController, LatLng(court.lat, court.lng));
      } catch (_) {
        // Map controller not ready yet — ignore, sheet still opens.
      }
    }
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

    return BlocConsumer<CourtsCubit, CourtsState>(
      listenWhen: (prev, curr) =>
          curr.pendingOverviewCourt != null &&
          prev.pendingOverviewCourt != curr.pendingOverviewCourt,
      listener: (context, state) {
        final court = state.pendingOverviewCourt!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showCourtOverview(court, state.sportTypes);
          context.read<CourtsCubit>().clearOverviewRequest();
        });
      },
      builder: (context, state) {
        // Handles the case where the request was set before this page
        // was built (PageView builds tabs lazily): open on first build.
        if (state.pendingOverviewCourt != null) {
          final court = state.pendingOverviewCourt!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _showCourtOverview(court, state.sportTypes);
            context.read<CourtsCubit>().clearOverviewRequest();
          });
        }
        return _buildContent(context, isDark, state);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isDark,
    CourtsState state,
  ) {
    final l10n = AppLocalizations.of(context);
    final loading = state.status == CourtsStatus.loading ||
        state.status == CourtsStatus.initial;

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
                AppSpacing.gapLG,
                // Sport category tabs
                if (state.sportTypes.isNotEmpty)
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: l10n.courtsFilterAll,
                          isSelected: _sportFilter == null,
                          onSelected: () => setState(() => _sportFilter = null),
                        ),
                        for (final sport in state.sportTypes.values) ...[
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: sport.name,
                            icon: sport.iconData,
                            isSelected: _sportFilter == sport.id,
                            onSelected: () =>
                                setState(() => _sportFilter = sport.id),
                          ),
                        ],
                      ],
                    ),
                  ),
                AppSpacing.gapMD,
                // Type / price filters
                Row(
                  children: [
                    _FilterChip(
                      label: l10n.courtsFilterIndoor,
                      isSelected: _typeFilter == 'indoor',
                      onSelected: () => setState(() => _typeFilter =
                          _typeFilter == 'indoor' ? null : 'indoor'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.courtsFilterOutdoor,
                      isSelected: _typeFilter == 'outdoor',
                      onSelected: () => setState(() => _typeFilter =
                          _typeFilter == 'outdoor' ? null : 'outdoor'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: l10n.courtsFilterFree,
                      isSelected: _freeOnly,
                      onSelected: () => setState(() => _freeOnly = !_freeOnly),
                    ),
                  ],
                ),
                AppSpacing.gapXL,
                Text(
                  l10n.courtsTitle,
                  style: AppTextStyles.h2.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                AppSpacing.gapMD,
                if (loading)
                  Skeletonizer(
                    enabled: true,
                    child: Column(
                      children: List.generate(
                        3,
                        (_) => const _CourtListTile(
                          name: 'Court name',
                          subtitle: 'Зал · Бесплатно',
                        ),
                      ),
                    ),
                  )
                else
                  Builder(
                    builder: (context) {
                      final filtered = _applyFilters(state.courts);
                      final child = filtered.isEmpty
                          ? Text(
                              l10n.courtsNotFound,
                              key: const ValueKey('empty'),
                              style: AppTextStyles.bodyMD.copyWith(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            )
                          : Column(
                              // Re-keyed per filter so the switcher animates.
                              key: ValueKey(
                                '$_sportFilter|$_typeFilter|$_freeOnly',
                              ),
                              children: filtered
                                  .map(
                                    (court) => _CourtListTile(
                                      name: court.name,
                                      subtitle: court.subtitle,
                                      onTap: () => _showCourtOverview(
                                        court,
                                        state.sportTypes,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.06, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: icon == null
          ? null
          : Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : null,
            ),
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected == null ? null : (_) => onSelected!(),
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

class _SingleCourtOverview extends StatelessWidget {
  const _SingleCourtOverview({required this.court, this.sportType});

  final CourtModel court;
  final SportTypeModel? sportType;

  Future<void> _openWhatsApp(BuildContext context) async {
    final uri = Uri.parse('https://wa.me/${court.whatsappDigits}');
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).courtsWhatsappError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (court.imageUrls.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: court.imageUrls.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: AppRadius.brSM,
                child: Image.network(
                  court.imageUrls[index],
                  width: 110,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 110,
                    height: 100,
                    color: isDark
                        ? AppColors.darkSurface2
                        : AppColors.lightSurface2,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (sportType != null)
              _OverviewChip(
                icon: sportType!.iconData,
                label: sportType!.name,
              ),
            _OverviewChip(label: court.subtitle),
          ],
        ),
        if (court.schedule.isNotEmpty) ...[
          AppSpacing.gapLG,
          Row(
            children: [
              Text(
                AppLocalizations.of(context).courtsOpenHours,
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
        ],
        if (court.whatsapp.isNotEmpty) ...[
          AppSpacing.gapLG,
          FilledButton.icon(
            onPressed: () => _openWhatsApp(context),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.brPill,
              ),
            ),
            icon: const Icon(Icons.chat_rounded, size: 20),
            label: Text('WhatsApp · ${court.whatsapp}'),
          ),
        ],
      ],
    );
  }
}

class _OverviewChip extends StatelessWidget {
  const _OverviewChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryMuted,
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelMD.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
