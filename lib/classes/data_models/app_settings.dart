class AppSettings {
  final bool isDarkMode;

  const AppSettings({
    required this.isDarkMode,
  });

  AppSettings copyWith({
    bool? isDarkMode,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}