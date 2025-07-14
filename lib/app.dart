import 'package:d_app/main_navigation.dart';
// import 'package:d_app/second_navigation.dart';
import 'package:d_app/themes/theme_provider.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  // final bool isDarkMode;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D_APP',
      theme: ThemeData(
        brightness: Brightness.light,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(TextStyle(fontFamily: 'Jura')),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'LXGW',
            fontSize: 20,
            color: Colors.black,
          ),
          backgroundColor: GeneralTheme.primary,
        ),
      ),
      darkTheme: ThemeData(
        // colorScheme: ColorScheme.dark(),
        brightness: Brightness.dark,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(TextStyle(fontFamily: 'Jura')),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontFamily: 'LXGW',
            fontSize: 20,
            color: Colors.black,
          ),
          backgroundColor: GeneralTheme.primary,
        ),
      ),
      themeMode: themeProvider.currentTheme,
      // themeMode: Provider.of<ThemeProvider>(context).currentTheme,
      home: const MainNavigation(),
    );
  }
}
