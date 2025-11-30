class AppSettings {
  final bool isDarkMode;
  final bool? isGuestMode;

  const AppSettings({
    required this.isDarkMode,
    required this.isGuestMode,
  });

  AppSettings copyWith({
    bool? isDarkMode,
    bool? isGuestMode,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isGuestMode: isGuestMode ?? this.isGuestMode,
    );
  }
}