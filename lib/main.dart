import 'package:flutter/material.dart';
import 'package:nyoom/themes/colors.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/pages/bus_times/bus_times.dart';
import 'package:nyoom/pages/travel_routes/travel_routes.dart';
import 'package:nyoom/pages/settings/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nyoom',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.mainBackgroundLight,
        colorScheme: ColorScheme.light(
          primary: AppColors.nyoomYellowLight,
          onPrimary: AppColors.white,
          secondary: AppColors.nyoomBlue,
          onSecondary: AppColors.white,
          tertiary: AppColors.nyoomGreen,
          onTertiary: AppColors.white,
          surface: AppColors.buttonPanelLight,
          onSurface: AppColors.hintGrayLight,
          error: AppColors.errorRed,
          onError: AppColors.white,
          outline: AppColors.darkGrayLight,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.mainBackgroundDark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.mainBackgroundDark,
          onPrimary: AppColors.nyoomYellowDark,
          secondary: AppColors.mainBackgroundDark,
          onSecondary: AppColors.nyoomBlue,
          tertiary: AppColors.mainBackgroundDark,
          onTertiary: AppColors.nyoomGreen,
          surface: AppColors.buttonPanelDark,
          onSurface: AppColors.hintGrayDark,
          error: AppColors.errorRed,
          onError: AppColors.white,
          outline: AppColors.darkGrayDark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainPageState();
}

class _MainPageState extends State<Main> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Bookmarks(),
    BusTimes(),
    TravelRoutes(),
    Settings(),
  ];
    final List<Color> _pageColors = const [
    AppColors.nyoomYellowLight,
    AppColors.nyoomBlue,
    AppColors.nyoomGreen,
    AppColors.darkGrayLight,
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: _pageColors[_currentIndex],
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Bus Times',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Travel Routes'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}