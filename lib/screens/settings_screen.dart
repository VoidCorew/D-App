import 'package:d_app/themes/theme_provider.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Основные',
                  style: TextStyle(fontFamily: 'Jura', fontSize: 20),
                ),

                ListTile(
                  leading: Icon(Icons.dark_mode),
                  trailing: Switch(
                    activeColor: GeneralTheme.primary,
                    value: Provider.of<ThemeProvider>(context).isDark,
                    onChanged:
                        (value) =>
                            Provider.of<ThemeProvider>(
                              context,
                              listen: false,
                            ).toggleTheme(),
                  ),
                  title: const Text(
                    'Темная тема',
                    style: GeneralTheme.listTileTitleStyle,
                  ),
                  subtitle: const Text(
                    'Включить темную тему',
                    style: GeneralTheme.listTileSubtitleStyle,
                  ),
                ),
              ],
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Row(
            //       children: [
            //         Icon(Icons.dark_mode),

            //         const SizedBox(width: 20),

            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               'Темная тема',
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 // fontWeight: FontWeight.bold,
            //               ),
            //             ),

            //             const SizedBox(height: 5),

            //             Text(
            //               'Включить темную тему',
            //               style: TextStyle(color: Colors.grey),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),

            //     Switch(
            //       activeColor: GeneralTheme.primary,
            //       value: Provider.of<ThemeProvider>(context).isDark,
            //       onChanged:
            //           (value) =>
            //               Provider.of<ThemeProvider>(
            //                 context,
            //                 listen: false,
            //               ).toggleTheme(),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
