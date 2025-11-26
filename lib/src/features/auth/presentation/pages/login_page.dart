import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/src/features/auth/presentation/pages/register_trial_page.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
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

    // thêm theme để dùng đa theme
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Lắng nghe login để show toast + điều hướng Home
    ref.listen(loginNotifierProvider, (previous, next) {
      // Thành công
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.loginSuccess,
          position: ToastPosition.top,
        );

        // Điều hướng sang HomePage, thay thế luôn LoginPage
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        });
      }

      // Lỗi
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
                // minHeight = chiều cao viewport để bottom copyright dính đáy
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ===== TOP: language + logo + form =====
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        40.h.verticalSpace,
                        // Chọn ngôn ngữ
                        const Align(
                          alignment: Alignment.topRight,
                          child: SelectLanguage(),
                        ),

                        32.h.verticalSpace,

                        // Logo
                        Image.asset(
                          'assets/images/ic_logo.webp',
                          height: 96.h,
                          fit: BoxFit.contain,
                        ),

                        24.h.verticalSpace,

                        // Tiêu đề
                        Text(
                          strings.loginTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 18.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        20.h.verticalSpace,

                        // ===== FORM =====
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // --- Tài khoản ---
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

                              24.h.verticalSpace,

                              // --- Mật khẩu ---
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

                              8.h.verticalSpace,

                              // --- Lưu mật khẩu + Quên mật khẩu ---
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
                                      materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  4.w.horizontalSpace,
                                  Text(
                                    strings.rememberMe,
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 13.sp,
                                      // không set color cứng, để theo theme
                                    ),
                                  ),

                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      // TODO: điều hướng quên mật khẩu
                                    },
                                    child: Text(
                                      strings.forgotPassword,
                                      style: textTheme.bodySmall?.copyWith(
                                        fontSize: 13.sp,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              12.h.verticalSpace,

                              // --- Nút Đăng nhập ---
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
                                          .read(
                                        loginNotifierProvider
                                            .notifier,
                                      )
                                          .login(
                                        _userController.text.trim(),
                                        _passController.text,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: state.isLoading
                                      ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child:
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : Text(
                                    strings.loginButton,
                                    style: textTheme.labelLarge
                                        ?.copyWith(fontSize: 15.sp),
                                  ),
                                ),
                              ),

                              12.h.verticalSpace,

                              // --- Bạn chưa có tài khoản? Đăng ký ngay ---
                              Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      strings.noAccount,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontSize: 14.sp,
                                        // fallback: nếu bodyMedium.color null thì dùng onBackground
                                        color: (textTheme.bodyMedium?.color ?? colorScheme.onBackground)
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const RegisterTrialPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        strings.registerNow,
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          // nếu sợ primary trùng nền thì dùng onPrimary / secondary tuỳ theme
                                          color: colorScheme.primary,
                                          // hoặc tạm dùng:
                                          // color: Colors.teal,
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
                        16.h.verticalSpace,
                        Text(
                          strings.copyright('PHONGNP'),
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 14.sp,
                          ),
                        ),
                        4.h.verticalSpace,
                        Text(
                          strings.versionLabel('1'),
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 13.sp,
                          ),
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
