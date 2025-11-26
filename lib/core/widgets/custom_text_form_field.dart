import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.headerTrailing,
    this.enableClearButton = false,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? headerTrailing;

  /// Nếu true và không truyền suffixIcon riêng → tự vẽ nút X clear
  final bool enableClearButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final Widget? effectiveSuffixIcon = suffixIcon ??
        (enableClearButton
            ? IconButton(
          icon: Icon(
            Icons.close,
            size: 18.sp,
          ),
          onPressed: () => controller.clear(),
        )
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dòng label + "Hướng dẫn"
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            if (headerTrailing != null) headerTrailing!,
          ],
        ),
        6.h.verticalSpace,

        // Ô nhập giống ảnh: nền trắng, bo tròn, chỉ có hint bên trong
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(fontSize: 14.sp),
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey, // chữ “Nhập mật khẩu” màu xám
            ),
            prefixIcon: prefixIcon,
            suffixIcon: effectiveSuffixIcon,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: const Color(0xFFE0E0E0), // viền xám nhạt
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
          ),
        ),
      ],
    );
  }
}
