import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// Service for controlling map operations and location services.
class MapService {
  /// Default initial center position (Bishkek, Kyrgyzstan).
  static const LatLng defaultCenter = LatLng(42.8746, 74.5698);
  static const double defaultZoom = 13.0;

  /// Get current user location.
  /// Returns null if permission is denied or location is unavailable.
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Convert Position to LatLng.
  LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  /// Move map controller to a specific location.
  void goToLocation(MapController mapController, LatLng location, {double zoom = 15.0}) {
    mapController.move(location, zoom);
  }

  /// Move map controller to current user location.
  Future<void> goToCurrentLocation(MapController mapController) async {
    final position = await getCurrentLocation();
    if (position != null) {
      final location = positionToLatLng(position);
      goToLocation(mapController, location);
    }
  }

  /// Create a marker for a court location.
  Marker createCourtMarker({
    required String markerId,
    required LatLng point,
    required String title,
    String? subtitle,
    Widget? child,
  }) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      alignment: Alignment.topCenter,
      child: child ??
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.sports_basketball,
              color: Colors.orange,
              size: 24,
            ),
          ),
    );
  }

  /// Create a list of mock court markers for Bishkek.
  List<Marker> getMockCourtMarkers() {
    return [
      createCourtMarker(
        markerId: 'court_1',
        point: const LatLng(42.8746, 74.5698),
        title: 'Восток-5',
        subtitle: 'Улица · Бесплатно',
      ),
      createCourtMarker(
        markerId: 'court_2',
        point: const LatLng(42.8800, 74.5800),
        title: 'Спартак',
        subtitle: 'Зал · Платно',
      ),
      createCourtMarker(
        markerId: 'court_3',
        point: const LatLng(42.8700, 74.5600),
        title: 'Бишкек Арена',
        subtitle: 'Зал · Платно',
      ),
    ];
  }

  /// Calculate distance between two coordinates in kilometers.
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    ) / 1000; // Convert meters to kilometers
  }

  /// Get center and zoom for bounds that include all markers.
  Map<String, dynamic> getBoundsForMarkers(List<Marker> markers) {
    if (markers.isEmpty) {
      return {
        'center': defaultCenter,
        'zoom': defaultZoom,
      };
    }

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (var marker in markers) {
      final lat = marker.point.latitude;
      final lng = marker.point.longitude;

      minLat = minLat < lat ? minLat : lat;
      maxLat = maxLat > lat ? maxLat : lat;
      minLng = minLng < lng ? minLng : lng;
      maxLng = maxLng > lng ? maxLng : lng;
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    // Calculate zoom level based on bounds
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    double zoom = 13.0;
    if (maxDiff > 0) {
      zoom = 15.0 - (maxDiff * 10);
      if (zoom < 10.0) zoom = 10.0;
      if (zoom > 18.0) zoom = 18.0;
    }

    return {
      'center': LatLng(centerLat, centerLng),
      'zoom': zoom,
    };
  }
}
