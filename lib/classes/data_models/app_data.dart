class AppData {
  final String username;
  final String email;
  final bool? isGuestMode;

  const AppData({
    required this.username,
    required this.email,
    required this.isGuestMode,
  });

  AppData copyWith({String? username, String? email, bool? isGuestMode}) {
    return AppData(
      username: username ?? this.username,
      email: email ?? this.email,
      isGuestMode: isGuestMode ?? this.isGuestMode,
    );
  }
}
