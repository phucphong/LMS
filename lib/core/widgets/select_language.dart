import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_language.dart';

class SelectLanguage extends ConsumerWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appLanguageProvider);
    final strings = AppStrings(lang);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _showLanguageSheet(context, ref, lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(strings.flagEmoji),
            const SizedBox(width: 6),
            Text(
              strings.shortCode,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet(
      BuildContext context, WidgetRef ref, AppLanguage current) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final langs = AppLanguage.values;

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Chọn ngôn ngữ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                itemCount: langs.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (_, index) {
                  final l = langs[index];
                  final s = AppStrings(l);
                  final selected = l == current;

                  return ListTile(
                    leading: Text(
                      s.flagEmoji,
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(s.languageName),
                    trailing: selected
                        ? Icon(Icons.check,
                        color: Theme.of(context).colorScheme.primary)
                        : null,
                    onTap: () {
                      ref.read(appLanguageProvider.notifier).state = l;
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
