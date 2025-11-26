import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/widgets/custom_button.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
import '../providers/register_trial_notifier.dart';

/// ===========================================================================
///  MÀN HÌNH ĐĂNG KÝ TÀI KHOẢN
/// ===========================================================================
class RegisterTrialPage extends ConsumerStatefulWidget {
  const RegisterTrialPage({super.key});

  @override
  ConsumerState<RegisterTrialPage> createState() =>
      _RegisterTrialPageState();
}

class _RegisterTrialPageState extends ConsumerState<RegisterTrialPage> {
  /// Key để validate form
  final _formKey = GlobalKey<FormState>();

  /// Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Ẩn/hiện mật khẩu
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _accountController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// State hiện tại của luồng đăng ký
    final state = ref.watch(registerTrialNotifierProvider);

    /// Lấy strings đa ngôn ngữ
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Lắng nghe kết quả đăng ký để show toast + điều hướng
    ref.listen(registerTrialNotifierProvider, (previous, next) {
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.registerTrialSuccess,
          position: ToastPosition.top,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }

      if (next.error != null && next.error!.isNotEmpty) {
        showErrorToast(
          context,
          next.error!,
          position: ToastPosition.top,
        );
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          strings.registerTrialTitle, // "Đăng ký tài khoản"
          style: textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: SelectLanguage(),
          ),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                24.w,
                12.h,
                24.w,
                12.h + bottomInset,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.h.verticalSpace,

                  Text(
                    strings.whoAreYou,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  24.h.verticalSpace,

                  // ==================== FORM ====================
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// HỌ VÀ TÊN
                        CustomTextFormField(
                          label: strings.fullNameLabel,
                          hintText: strings.fullNameHint,
                          controller: _nameController,
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.fullNameRequired
                              : null,
                        ),

                        24.h.verticalSpace,

                        /// SỐ ĐIỆN THOẠI
                        CustomTextFormField(
                          label: strings.phoneLabel,
                          hintText: strings.phoneHint,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.phoneRequired
                              : null,
                        ),

                        24.h.verticalSpace,

                        /// EMAIL
                        CustomTextFormField(
                          label: strings.emailLabel,
                          hintText: strings.emailHint,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.emailRequired
                              : null,
                            headerTrailing: GestureDetector(
                              onTap: () {
                                // mở hướng dẫn
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.help_outline, size: 16.sp, color: Colors.redAccent),
                                  4.w.horizontalSpace,
                                  Text(
                                    'Hướng dẫn',
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ),

                        24.h.verticalSpace,

                        /// TÀI KHOẢN / USERNAME
                    CustomTextFormField(
                      label: strings.accountLabel,
                      hintText: strings.accountHint,
                      controller: _accountController,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.credit_card, size: 20.sp),
                      enableClearButton: true,          // tự có nút X
                      validator: (v) => (v == null || v.isEmpty)
                          ? strings.usernameRequired
                          : null,

                    ),


                        24.h.verticalSpace,

                        /// MẬT KHẨU
                      CustomTextFormField(
                        label: strings.passwordLabel,
                        // <--- thêm dòng này
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscurePassword,
                        prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            size: 20.sp,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (v) =>
                        (v == null || v.isEmpty) ? strings.passwordRequired : null,
                      ),


                        24.h.verticalSpace,

                        /// NÚT ĐĂNG KÝ
                      CustomButton(
                        text: strings.registerButton,
                        isLoading: state.isLoading,
                        enabled: !state.isLoading, // luôn enable khi không load
                        onPressed: () {
                          if (!(_formKey.currentState?.validate() ?? false)) {
                            return;
                          }

                          ref.read(registerTrialNotifierProvider.notifier).register(
                            hoten: _nameController.text.trim(),
                            dienthoai: _phoneController.text.trim(),
                            email: _emailController.text.trim(),
                            username: _accountController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        },
                      ),


                        24.h.verticalSpace,

                        /// TEXT DƯỚI: mô tả + "Đăng nhập tại đây"
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              '${strings.registerTrialDescription} ',
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                color: (textTheme.bodySmall?.color ??
                                    colorScheme.onBackground)
                                    .withOpacity(0.7),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                strings.loginHere,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
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
            );
          },
        ),
      ),
    );
  }
}
