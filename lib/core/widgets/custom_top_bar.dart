import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTopBar extends StatelessWidget {
  const CustomTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.h,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF07A7FF), Color(0xFF04D3E5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          /// BACK BUTTON
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 22.sp,
            ),
            onPressed: onBack ?? () => Navigator.of(context).pop(),
          ),

          /// TITLE
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          /// TRAILING (hoặc placeholder để căn giữa)
          trailing ??
              SizedBox(
                width: 40.w,
                height: 40.w,
              ),
        ],
      ),
    );
  }
}
