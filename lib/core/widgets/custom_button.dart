import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final bool enabled;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.enabled = true,
    this.onPressed,
    this.height = 48,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bgColor = enabled
        ? theme.colorScheme.primary   // xanh khi active
        : Colors.grey.shade300;        // xám khi disabled

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(
          enabled ? borderRadius.r : 6.r, // giảm radius khi disable
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(
            enabled ? borderRadius.r : 6.r,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
