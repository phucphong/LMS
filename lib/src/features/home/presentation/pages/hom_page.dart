import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LMS Home',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64.sp,
                color: Colors.teal,
              ),
              16.h.verticalSpace,
              Text(
                'Đăng nhập thành công!',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              8.h.verticalSpace,
              Text(
                'Đây là màn hình HomePage demo.\nSau này mình sẽ thay bằng dashboard LMS.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              24.h.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  // Tạm thời: logout quay lại LoginPage nếu cần
                  Navigator.pop(context);
                },
                child: Text(
                  'Quay lại Login',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
