import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_language.dart';

class SelectLanguage extends ConsumerWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appLanguageProvider);
    final strings = AppStrings(lang);
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20.r),
      onTap: () => _openLanguageBottomSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              strings.flagEmoji,
              style: TextStyle(fontSize: 16.sp),
            ),
            SizedBox(width: 6.w),
            Text(
              strings.shortCode,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLanguageBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => const _LanguageBottomSheet(),
    );
  }
}

/// BottomSheet chọn ngôn ngữ
class _LanguageBottomSheet extends ConsumerWidget {
  const _LanguageBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(currentLang);
    final langs = AppLanguage.values;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          // drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            strings.selectLanguageTitle, // "Chọn ngôn ngữ"
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: langs.length,
            separatorBuilder: (_, __) => Divider(
              height: 1.h,
              color: Colors.grey.shade300,
            ),
            itemBuilder: (context, index) {
              final lang = langs[index];
              final s = AppStrings(lang);
              final selected = lang == currentLang;

              return ListTile(
                leading: Text(
                  s.flagEmoji,
                  style: TextStyle(fontSize: 22.sp),
                ),
                title: Text(
                  s.languageName,
                  style: TextStyle(fontSize: 14.sp),
                ),
                trailing: selected
                    ? Icon(
                  Icons.check,
                  color: theme.colorScheme.primary,
                  size: 20.sp,
                )
                    : null,
                onTap: () {
                  ref.read(appLanguageProvider.notifier).state = lang;
                  Navigator.of(context).pop();
                },
              );
            },
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
