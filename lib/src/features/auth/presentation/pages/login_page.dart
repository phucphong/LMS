import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/src/features/auth/presentation/pages/register_trial_page.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
import '../providers/login_notifier.dart';
import 'forgot_password_page.dart';

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

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Lắng nghe state login để show toast + điều hướng
    ref.listen(loginNotifierProvider, (previous, next) {
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.loginSuccess,
          position: ToastPosition.top,
        );

        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        });
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
      // Cho phép layout tự đẩy lên khi bàn phím mở
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              // Khi bàn phím mở, thêm padding bottom = chiều cao bàn phím
              padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 12.h,
                bottom: (bottomInset > 0 ? bottomInset : 12.h),
              ),
              child: ConstrainedBox(
                // Đảm bảo tối thiểu = chiều cao màn hình (trừ padding),
                // để bình thường vẫn kê được copyright ở đáy
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // =============== PHẦN TRÊN: LOGO + FORM ===============
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          40.h.verticalSpace,

                          const Align(
                            alignment: Alignment.topRight,
                            child: SelectLanguage(),
                          ),

                          32.h.verticalSpace,

                          Image.asset(
                            'assets/images/ic_logo.webp',
                            height: 96.h,
                            fit: BoxFit.contain,
                          ),

                          24.h.verticalSpace,

                          Text(
                            strings.loginTitle,
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 18.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          20.h.verticalSpace,

                          /// ================= FORM LOGIN =================
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                /// ---------- Ô TÀI KHOẢN ----------
                                CustomTextFormField(
                                  label: strings.usernameLabel,
                                  hintText: strings.usernameLabel,
                                  controller: _userController,
                                  keyboardType: TextInputType.text,
                                  prefixIcon: Icon(
                                    Icons.credit_card,
                                    size: 20.sp,
                                  ),
                                  enableClearButton: true,
                                  validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? strings.usernameRequired
                                      : null,

                                ),

                                20.h.verticalSpace,

                                /// --------------------- Ô MẬT KHẨU ---------------------
                                CustomTextFormField(
                                  label: strings.passwordLabel,
                                  hintText: strings.passwordLabel,
                                  controller: _passController,
                                  keyboardType:
                                  TextInputType.visiblePassword,
                                  obscureText: _obscurePassword,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    size: 20.sp,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 20.sp,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                        !_obscurePassword;
                                      });
                                    },
                                  ),
                                  validator: (v) =>
                                  (v == null || v.isEmpty)
                                      ? strings.passwordRequired
                                      : null,
                                ),

                                8.h.verticalSpace,

                                /// -------- LƯU MẬT KHẨU + QUÊN MẬT KHẨU --------
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
                                        visualDensity:
                                        VisualDensity.compact,
                                        materialTapTargetSize:
                                        MaterialTapTargetSize
                                            .shrinkWrap,
                                      ),
                                    ),
                                    4.w.horizontalSpace,
                                    Text(
                                      strings.rememberMe,
                                      style:
                                      textTheme.bodySmall?.copyWith(
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const ForgotPasswordPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        strings.forgotPassword,
                                        style: textTheme.bodySmall
                                            ?.copyWith(
                                          fontSize: 13.sp,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                12.h.verticalSpace,

                                /// --------------------- NÚT ĐĂNG NHẬP ---------------------
                              CustomButton(
                                text: strings.loginButton,
                                isLoading: state.isLoading,
                                enabled: !state.isLoading,
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    ref.read(loginNotifierProvider.notifier).login(
                                      _userController.text.trim(),
                                      _passController.text,
                                    );
                                  }
                                },
                              ),


                                12.h.verticalSpace,

                                /// --------------------- ĐĂNG KÝ NGAY ---------------------
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      strings.noAccount,
                                      style: textTheme.bodyMedium
                                          ?.copyWith(
                                        fontSize: 14.sp,
                                        color: (textTheme.bodyMedium
                                            ?.color ??
                                            colorScheme
                                                .onBackground)
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const RegisterTrialPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        strings.registerNow,
                                        style: textTheme.bodyMedium
                                            ?.copyWith(
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

                      // =============== PHẦN DƯỚI: COPYRIGHT ===============
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
          },
        ),
      ),
    );
  }
}
