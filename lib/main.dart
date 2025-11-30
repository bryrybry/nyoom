import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/pages/bus_times/bus_times.dart';
import 'package:nyoom/pages/misc/startup.dart';
import 'package:nyoom/pages/travel_routes/travel_routes.dart';
import 'package:nyoom/pages/settings/settings.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initHive();
  runApp(
    ScreenUtilInit(
      designSize: const Size(1284, 2778),
      minTextAdapt: true,
      builder: (context, child) {
        return ProviderScope(child: const Nyoom());
      },
    ),
  );
}

class Nyoom extends ConsumerWidget {
  const Nyoom({super.key});

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
      themeMode: ref.watch(settingsProvider).isDarkMode
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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(navigationProvider.notifier).setCallback(onNavigate);
    });
  }

  int _currentIndex = 0;
  Widget page = Startup();

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

  void onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
      page = _pages[_currentIndex];
    });
  }

  void onNavigate(Widget newPage) {
    setState(() {
      page = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = _pageColors[_currentIndex];
    final icon = _pageIcons[_currentIndex];
    String? pageTitle;
    bool hasNavBar = true;
    if (page is PageSettings) {
      final pageData = page as PageSettings;
      pageTitle = pageData.pageTitle;
      hasNavBar = !pageData.noNavBar;
    }
    return Scaffold(
      appBar: pageTitle != null ? AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Icon(icon, color: AppColors.white),
              const SizedBox(width: 8),
              Text(
                pageTitle,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ) : null,
      body: Padding(
        padding: EdgeInsets.only(top: pageTitle == null ? 90.h : 0),
        child: page,
      ),
      backgroundColor: ref.watch(settingsProvider).isDarkMode
          ? AppColors.mainBackground(ref)
          : color,
      bottomNavigationBar: hasNavBar ? BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.navBarPanel(ref),
        selectedItemColor: color,
        iconSize: 90.h,
        onTap: onNavBarTapped,
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
      ) : null,
    );
  }
}

abstract class PageSettings {
  String? get pageTitle;
  bool get noNavBar => false;
}
