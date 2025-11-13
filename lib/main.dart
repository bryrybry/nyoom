import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/themes/colors.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/pages/bus_times/bus_times.dart';
import 'package:nyoom/pages/travel_routes/travel_routes.dart';
import 'package:nyoom/pages/settings/settings.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: Size(1284, 2778), // bry's iPhone 13 Pro Max size
      minTextAdapt: true,
      builder: (context, child) {
        return ProviderScope(child: const MyApp());
      },
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Nyoom',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'AlbertSans',
        scaffoldBackgroundColor: AppColors.mainBackground(ref),
        colorScheme: ColorScheme.light(
          primary: AppColors.nyoomYellow(ref),
          onPrimary: AppColors.white,
          secondary: AppColors.nyoomBlue,
          onSecondary: AppColors.white,
          tertiary: AppColors.nyoomGreen,
          onTertiary: AppColors.white,
          surface: AppColors.buttonPanel(ref),
          onSurface: AppColors.hintGray(ref),
          error: AppColors.errorRed,
          onError: AppColors.white,
          outline: AppColors.darkGray(ref),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'AlbertSans',
        scaffoldBackgroundColor: AppColors.mainBackground(ref),
        colorScheme: ColorScheme.dark(
          primary: AppColors.mainBackground(ref),
          onPrimary: AppColors.nyoomYellow(ref),
          secondary: AppColors.mainBackground(ref),
          onSecondary: AppColors.nyoomBlue,
          tertiary: AppColors.mainBackground(ref),
          onTertiary: AppColors.nyoomGreen,
          surface: AppColors.buttonPanel(ref),
          onSurface: AppColors.hintGray(ref),
          error: AppColors.errorRed,
          onError: AppColors.white,
          outline: AppColors.darkGray(ref),
        ),
      ),
      themeMode: ref.watch(isDarkModeProvider)
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const Main(),
    );
  }
}

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  ConsumerState<Main> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<Main> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Bookmarks(),
    BusTimes(),
    TravelRoutes(),
    Settings(),
  ];

  List<Color> get _pageColors => [
    AppColors.nyoomYellow(ref),
    AppColors.nyoomBlue,
    AppColors.nyoomGreen,
    AppColors.hintGray(ref),
  ];
  final List<IconData> _pageIcons = const [
    Icons.bookmark,
    Icons.directions_bus,
    Icons.location_pin,
    Icons.settings,
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentIndex];
    final color = _pageColors[_currentIndex];
    final icon = _pageIcons[_currentIndex];
    AppBar? appBar;
    if (page is HasPageTitle) {
      final pageData = page as HasPageTitle;
      appBar = AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              pageData.pageTitle ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      body: page,
      backgroundColor: ref.watch(isDarkModeProvider) ? AppColors.mainBackground(ref) : color,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.navBarPanel(ref),
        selectedItemColor: color,
        iconSize: 90.h,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 45.sp,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w600,
        ),
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
            label: 'Travel Routes',
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

abstract class HasPageTitle {
  String? get pageTitle;
}
