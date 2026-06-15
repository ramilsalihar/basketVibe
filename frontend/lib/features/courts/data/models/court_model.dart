import 'package:cloud_firestore/cloud_firestore.dart';

/// Court data from the `courts/{courtId}` Firestore document.
///
/// Firestore document shape:
/// ```
/// name: string        — title shown in lists
/// address: string
/// city: string
/// lat, lng: number
/// isFree: bool
/// type: 'indoor' | 'outdoor'
/// schedule: string     — opening hours, e.g. "09:00 - 23:00"
/// imageUrls: string[]  — photos of the place
/// whatsapp: string     — contact number, e.g. "+996 700 123 456"
/// sportTypeId: string  — references sportTypes/{id}, e.g. "basketball"
/// ```
class CourtModel {
  const CourtModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.lat,
    required this.lng,
    required this.isFree,
    required this.type,
    this.schedule = '',
    this.imageUrls = const [],
    this.whatsapp = '',
    this.sportTypeId = '',
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final double lat;
  final double lng;
  final bool isFree;

  /// 'indoor' or 'outdoor'.
  final String type;

  /// Opening hours, e.g. "09:00 - 23:00". Empty if unknown.
  final String schedule;

  /// Photos of the place; first one is used as the card cover.
  final List<String> imageUrls;

  /// Contact number in "+996 700 123 456" form. Empty if none.
  final String whatsapp;

  /// References `sportTypes/{id}`, e.g. "basketball".
  final String sportTypeId;

  factory CourtModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return CourtModel(
      id: doc.id,
      name: data['name'] as String,
      address: data['address'] as String? ?? '',
      city: data['city'] as String? ?? '',
      lat: (data['lat'] as num?)?.toDouble() ?? 0,
      lng: (data['lng'] as num?)?.toDouble() ?? 0,
      isFree: data['isFree'] as bool? ?? true,
      type: data['type'] as String? ?? 'outdoor',
      schedule: data['schedule'] as String? ?? '',
      imageUrls:
          (data['imageUrls'] as List<dynamic>? ?? const []).cast<String>(),
      whatsapp: data['whatsapp'] as String? ?? '',
      sportTypeId: data['sportTypeId'] as String? ?? '',
    );
  }

  /// Digits-only form for wa.me links, e.g. "996700123456".
  String get whatsappDigits => whatsapp.replaceAll(RegExp(r'[^0-9]'), '');

  /// Short display line, e.g. "Зал · Платно".
  String get subtitle =>
      '${type == 'indoor' ? 'Зал' : 'Улица'} · ${isFree ? 'Бесплатно' : 'Платно'}';
}
