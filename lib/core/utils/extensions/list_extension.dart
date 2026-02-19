extension ListExtension<T> on List<T> {
  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;

  /// Check if list is not empty
  bool get isNotEmpty => !isEmpty;

  /// Add element if not null
  void addIfNotNull(T? item) {
    if (item != null) add(item);
  }

  /// Add all elements if not null
  void addAllIfNotNull(Iterable<T>? items) {
    if (items != null) addAll(items);
  }
}
