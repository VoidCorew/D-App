import 'package:d_app/app.dart';
import 'package:d_app/models/save_glucose_entry.dart';
import 'package:d_app/providers/glucose_provider.dart';
import 'package:d_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SaveGlucoseEntryAdapter());
  Hive.registerAdapter(MeasureUnitAdapter());
  await Hive.openBox<SaveGlucoseEntry>('glucoseBox');
  await Hive.openBox<SaveGlucoseEntry>('trashedGlucoseBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => GlucoseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
