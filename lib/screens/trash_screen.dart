import 'package:d_app/models/save_glucose_entry.dart';
import 'package:d_app/providers/glucose_provider.dart';
import 'package:d_app/utils/general_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final glucoseProvider = context.watch<GlucoseProvider>();
    final deletedItems = glucoseProvider.trashed;

    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: ListView.builder(
        itemCount: deletedItems.length,
        itemBuilder: (context, index) {
          final entry = deletedItems[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: StretchMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    showDeleteDialog(context, glucoseProvider, entry);
                  },
                  icon: Icons.delete,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                ),
                SlidableAction(
                  onPressed: (context) {
                    glucoseProvider.restoreEntry(entry);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Запись успешно восстановлена'),
                      ),
                    );
                    // Navigator.pop(context);
                  },
                  icon: Icons.restore,
                  backgroundColor: Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                '${entry.value.toStringAsFixed(1)} ${glucoseProvider.unitText(entry)}',
                style: GeneralTheme.listTileTitleStyle,
              ),
              subtitle: Text(
                DateFormat('HH:mm | yyyy-MM-dd').format(entry.date),
                style: GeneralTheme.listTileSubtitleStyle,
              ),
            ),
          );
        },
      ),
    );
  }

  void showDeleteDialog(
    BuildContext context,
    GlucoseProvider glucoseProvider,
    SaveGlucoseEntry entry,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Удалить запись'),
            content: const Text(
              'Вы действительно хотите удалить эту запись безвозвратно?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () {
                  glucoseProvider.deleteForever(entry);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: const Text('Запись успешно удалена')),
                  );
                },
                child: const Text('Удалить'),
              ),
            ],
          ),
    );
  }
}
