import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
import '../providers/register_trial_notifier.dart';


class RegisterTrialPage extends ConsumerStatefulWidget {
  const RegisterTrialPage({super.key});

  @override
  ConsumerState<RegisterTrialPage> createState() => _RegisterTrialPageState();
}

class _RegisterTrialPageState extends ConsumerState<RegisterTrialPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isParent = true;
  String? _selectedGrade;

  final List<String> _grades = [
    'Lớp 1',
    'Lớp 2',
    'Lớp 3',
    'Lớp 4',
    'Lớp 5',
    'Lớp 6',
    'Lớp 7',
    'Lớp 8',
    'Lớp 9',
    'Lớp 10',
    'Lớp 11',
    'Lớp 12',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerTrialNotifierProvider);
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    // lắng nghe để show toast + điều hướng
    ref.listen(registerTrialNotifierProvider, (previous, next) {
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.registerTrialSuccess,
          position: ToastPosition.top,
        );

        // Điều hướng sang HomePage sau khi đăng ký
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          strings.registerTrialTitle,
          style: TextStyle(
            fontSize: 18.sp,
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
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ===== TOP: form =====
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        12.h.verticalSpace,
                        Text(
                          strings.whoAreYou,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        8.h.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                value: true,
                                groupValue: _isParent,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                onChanged: (v) {
                                  setState(() => _isParent = v ?? true);
                                },
                                title: Text(
                                  strings.parentOption,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                value: false,
                                groupValue: _isParent,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                onChanged: (v) {
                                  setState(() => _isParent = v ?? false);
                                },
                                title: Text(
                                  strings.studentOption,
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ],
                        ),

                        16.h.verticalSpace,

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Họ và tên
                              TextFormField(
                                controller: _nameController,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: strings.fullNameLabel,
                                  hintText: strings.fullNameHint,
                                  labelStyle: TextStyle(fontSize: 13.sp),
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? strings.fullNameRequired
                                    : null,
                              ),

                              16.h.verticalSpace,

                              // Số điện thoại
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: TextStyle(fontSize: 14.sp),
                                decoration: InputDecoration(
                                  labelText: strings.phoneLabel,
                                  hintText: strings.phoneHint,
                                  labelStyle: TextStyle(fontSize: 13.sp),
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                validator: (v) =>
                                (v == null || v.isEmpty)
                                    ? strings.phoneRequired
                                    : null,
                              ),

                              16.h.verticalSpace,

                              // Khối lớp (Dropdown)
                              DropdownButtonFormField<String>(
                                value: _selectedGrade,
                                items: _grades
                                    .map(
                                      (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(
                                      g,
                                      style:
                                      TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() => _selectedGrade = v);
                                },
                                decoration: InputDecoration(
                                  labelText: strings.gradeLabel,
                                  hintText: strings.gradeHint,
                                  labelStyle: TextStyle(fontSize: 13.sp),
                                  hintStyle: TextStyle(fontSize: 13.sp),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 10.h,
                                  ),
                                ),
                                validator: (v) =>
                                (v == null || v.isEmpty)
                                    ? strings.gradeRequired
                                    : null,
                              ),

                              24.h.verticalSpace,

                              SizedBox(
                                width: double.infinity,
                                height: 46.h,
                                child: ElevatedButton(
                                  onPressed: state.isLoading
                                      ? null
                                      : () {
                                    if (!(_formKey.currentState
                                        ?.validate() ??
                                        false)) {
                                      return;
                                    }
                                    if (_selectedGrade == null) {
                                      showErrorToast(
                                        context,
                                        strings.gradeRequired,
                                        position: ToastPosition.top,
                                      );
                                      return;
                                    }

                                    ref
                                        .read(
                                        registerTrialNotifierProvider
                                            .notifier)
                                        .register(
                                      isParent: _isParent,
                                      fullName:
                                      _nameController.text.trim(),
                                      phone: _phoneController.text
                                          .trim(),
                                      grade: _selectedGrade!,
                                    );
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
                                    strings.startLearningButton,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // ===== BOTTOM text: nếu đã có tài khoản... Đăng nhập tại đây =====
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        24.h.verticalSpace,
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              '${strings.registerTrialDescription} ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // quay về Login
                              },
                              child: Text(
                                strings.loginHere,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
