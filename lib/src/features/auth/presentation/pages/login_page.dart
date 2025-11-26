import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/select_language.dart';
import '../providers/login_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginNotifierProvider);
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    // lắng nghe login để show toast
    ref.listen(loginNotifierProvider, (previous, next) {
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.loginSuccess,
          position: ToastPosition.top,
        );
      }
      if (next.error != null && next.error!.isNotEmpty) {
        showErrorToast(
          context,
          strings.loginError,
          position: ToastPosition.top,
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              child: ConstrainedBox(
                constraints:
                BoxConstraints(minHeight: constraints.maxHeight - 24.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ===== TOP: chọn ngôn ngữ + logo + form =====
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // chọn ngôn ngữ
                        const Align(
                          alignment: Alignment.topRight,
                          child: SelectLanguage(),
                        ),

                        SizedBox(height: 32.h),

                        // logo
                        Image.asset(
                          'assets/images/ic_logo.webp',
                          height: 96.h,
                          fit: BoxFit.contain,
                        ),

                        SizedBox(height: 24.h),

                        Text(
                          strings.loginTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 20.h),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Tài khoản
                              TextFormField(
                                controller: _userController,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: strings.usernameLabel,
                                  labelStyle: TextStyle(fontSize: 13.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? strings.usernameRequired
                                    : null,
                              ),

                              SizedBox(height: 16.h),

                              // Mật khẩu
                              TextFormField(
                                controller: _passController,
                                obscureText: _obscurePassword,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: strings.passwordLabel,
                                  labelStyle: TextStyle(fontSize: 13.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20.sp,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? strings.passwordRequired
                                    : null,
                              ),

                              SizedBox(height: 8.h),

                              // Lưu mật khẩu + Quên mật khẩu
                              Row(
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (v) {
                                        setState(() {
                                          _rememberMe = v ?? false;
                                        });
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    strings.rememberMe,
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: điều hướng quên mật khẩu
                                    },
                                    child: Text(
                                      strings.forgotPassword,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 12.h),

                              // Nút đăng nhập
                              SizedBox(
                                width: double.infinity,
                                height: 44.h,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                    if (_formKey.currentState
                                        ?.validate() ??
                                        false) {
                                      ref
                                          .read(loginNotifierProvider
                                          .notifier)
                                          .login(
                                        _userController.text.trim(),
                                        _passController.text,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: state.isLoading
                                      ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    strings.loginButton,
                                    style:
                                    TextStyle(fontSize: 15.sp),
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              // Đăng ký tài khoản
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      strings.noAccount,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // TODO: navigate register
                                      },
                                      child: Text(
                                        strings.registerNow,
                                        style: TextStyle(
                                          color: Colors.teal,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                    // ===== BOTTOM: copyright =====
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          strings.copyright('PHONGNP'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          strings.versionLabel('1'),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
