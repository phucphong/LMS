import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/src/features/auth/presentation/pages/register_trial_page.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
import '../providers/login_notifier.dart';

/// ===========================================================================
///  MÀN HÌNH LOGIN CỦA ỨNG DỤNG LMS
///  Người tạo: **Phongnp – 0964 931 224**
///
///  GIẢI THÍCH CHUNG:
///  - Dùng **Riverpod** để quản lý state đăng nhập
///  - Dùng **ScreenUtil** để responsive theo kích thước màn hình
///  - Dùng **AppStrings** + **AppLanguage** để hỗ trợ đa ngôn ngữ
///  - Login thành công → điều hướng sang HomePage
///  - Hiển thị Toast khi login lỗi/thành công
/// ===========================================================================
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  /// KEY form kiểm tra hợp lệ username/password
  final _formKey = GlobalKey<FormState>();

  /// Controller quản lý text nhập của người dùng
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  /// Trạng thái Checkbox "Lưu mật khẩu"
  bool _rememberMe = false;

  /// Trạng thái ẩn/hiện mật khẩu
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Lấy toàn bộ state login (isLoading, success, error)
    final state = ref.watch(loginNotifierProvider);

    /// Lấy ngôn ngữ hiện tại
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    /// Theme hiện tại của ứng dụng (màu sắc + kiểu chữ)
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // ================================================================
    // LẮNG NGHE SỰ KIỆN LOGIN:
    // - Thành công: show success toast + chuyển trang Home
    // - Thất bại: show error toast
    // ================================================================
    ref.listen(loginNotifierProvider, (previous, next) {
      // Nếu login OK → điều hướng sang HomePage
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.loginSuccess,
          position: ToastPosition.top,
        );

        Future.microtask(() {
          /// pushReplacement → thay thế luôn Login (không cho back lại)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        });
      }

      // Nếu có lỗi login → hiển thị Toast lỗi
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
        child: Padding(
          /// Padding toàn màn hình
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 12.h,
          ),

          /// ===========================
          /// Layout chính chia 2 phần:
          ///   1. Khu vực Form Login (phía trên)
          ///   2. Khu vực Copyright (phía dưới)
          /// ===========================
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ==============================
              // PHẦN TRÊN: Logo + Form
              // ==============================
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  40.h.verticalSpace,

                  /// Widget chọn ngôn ngữ, nằm góc phải
                  const Align(
                    alignment: Alignment.topRight,
                    child: SelectLanguage(),
                  ),

                  32.h.verticalSpace,

                  /// Logo của ứng dụng
                  Image.asset(
                    'assets/images/ic_logo.webp',
                    height: 96.h,
                    fit: BoxFit.contain,
                  ),

                  24.h.verticalSpace,

                  /// Dòng chữ "Đăng nhập hệ thống"
                  Text(
                    strings.loginTitle,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: 18.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  20.h.verticalSpace,

                  /// =====================================================
                  ///                       FORM LOGIN
                  /// =====================================================
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// --------------------- Ô TÀI KHOẢN ---------------------
                        /// TextFormField có controller + validation
                        TextFormField(
                          controller: _userController,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.usernameLabel,  // "Tài khoản"
                            labelStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                          // Kiểm tra ô nhập có rỗng không
                          validator: (v) =>
                          (v == null || v.isEmpty)
                              ? strings.usernameRequired
                              : null,
                        ),

                        20.h.verticalSpace,

                        /// --------------------- Ô MẬT KHẨU ---------------------
                        TextFormField(
                          controller: _passController,
                          obscureText: _obscurePassword, // ẩn/hiện mật khẩu
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.passwordLabel, // "Mật khẩu"
                            labelStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),

                            /// Icon con mắt để bật/tắt xem mật khẩu
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

                          /// Kiểm tra xem mật khẩu có rỗng không
                          validator: (v) =>
                          (v == null || v.isEmpty)
                              ? strings.passwordRequired
                              : null,
                        ),

                        8.h.verticalSpace,

                        /// --------------------- LƯU MẬT KHẨU + QUÊN MẬT KHẨU ---------------------
                        Row(
                          children: [
                            /// Checkbox: Lưu mật khẩu
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
                              strings.rememberMe, // "Lưu mật khẩu"
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                              ),
                            ),

                            const Spacer(),

                            /// Nút "Quên mật khẩu?"
                            TextButton(
                              onPressed: () {
                                // TODO: Điều hướng quên mật khẩu (sẽ thêm sau)
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

                        /// --------------------- NÚT ĐĂNG NHẬP ---------------------
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null // đang loading → disable button
                                : () {
                              /// Kiểm tra form trước khi login
                              if (_formKey.currentState?.validate() ??
                                  false) {
                                ref
                                    .read(
                                  loginNotifierProvider.notifier,
                                )
                                    .login(
                                  _userController.text.trim(),
                                  _passController.text,
                                );
                              }
                            },

                            /// UI nút: bo góc, tự động disable khi loading
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),

                            /// Loading spinner khi đang login
                            child: state.isLoading
                                ? SizedBox(
                              width: 18.w,
                              height: 18.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              strings.loginButton, // "Đăng nhập"
                              style: textTheme.labelLarge?.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        ),

                        12.h.verticalSpace,

                        /// --------------------- ĐĂNG KÝ NGAY ---------------------
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              strings.noAccount, // "Bạn chưa có tài khoản?"
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 14.sp,
                                color: (textTheme.bodyMedium?.color ??
                                    colorScheme.onBackground)
                                    .withOpacity(0.7),
                              ),
                            ),

                            /// Nút "Đăng ký ngay"
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
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // =======================================================
              // PHẦN DƯỚI: COPYRIGHT + VERSION + NGƯỜI TẠO
              // =======================================================
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.h.verticalSpace,

                  /// Tên công ty / tác giả phần mềm
                  Text(
                    strings.copyright('PHONGNP'),
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),

                  4.h.verticalSpace,

                  /// Phiên bản ứng dụng + người tạo
                  Text(
                    '${strings.versionLabel('0964 931 225')} ',
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
      ),
    );
  }
}
