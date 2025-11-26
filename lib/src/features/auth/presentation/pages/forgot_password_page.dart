import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms/core/widgets/custom_button.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/custom_top_bar.dart';
import '../providers/forgot_password_notifier.dart';
import 'package:flutter/services.dart';
class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordNotifierProvider);
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    // Listen để show toast
    ref.listen(forgotPasswordNotifierProvider, (prev, next) {
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.forgotPasswordSuccess,
          position: ToastPosition.top,
        );
        // TODO: sau này điều hướng sang màn nhập OTP
      }
      if (next.error != null && next.error!.isNotEmpty) {
        showErrorToast(
          context,
          next.error!,
          position: ToastPosition.top,
        );
      }
    });

    final isButtonEnabled =
        !state.isLoading && (_phoneController.text.trim().isNotEmpty);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ==== AppBar gradient ====
            CustomTopBar(
          title: strings.forgotPasswordTitle,
        ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 24.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        strings.forgotPasswordDescription,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      24.h.verticalSpace,

                      // Ô nhập số điện thoại
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 14.sp),
                        decoration: InputDecoration(
                          labelText: strings.forgotPasswordHintText,
                          labelStyle: TextStyle(fontSize: 13.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty) {
                            return strings.forgotPasswordHintText;
                          }
                          // TODO: validate phone theo chuẩn VN nếu muốn
                          return null;
                        },
                        onChanged: (_) => setState(() {}),
                      ),

                      32.h.verticalSpace,

                    CustomButton(
                      text: strings.forgotPasswordSendCode,
                      isLoading: state.isLoading,
                      enabled: isButtonEnabled,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          ref
                              .read(forgotPasswordNotifierProvider.notifier)
                              .sendCode(_phoneController.text.trim());
                        }
                      },
                    ),


                      40.h.verticalSpace,

                      Text(
                        strings.hotlineHelpText('093.120.8686'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
