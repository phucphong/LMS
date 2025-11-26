import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_language.dart';
import '../../../../../core/widgets/custom_toast.dart';
import '../../../../../core/widgets/select_language.dart';

import '../../../home/presentation/pages/hom_page.dart';
import '../providers/register_trial_notifier.dart';

/// ===========================================================================
///  MÀN HÌNH ĐĂNG KÝ HỌC THỬ (RegisterTrialPage)
///  Người tạo: Phongnp – 0964 931 224
///
///  MỤC ĐÍCH:
///  - Cho phép người dùng đăng ký học thử bằng:
///      + Họ và tên
///      + Số điện thoại
///      + Khối lớp (Lớp 1 → Lớp 12)
///  - Sau khi đăng ký thành công:
///      + Hiển thị toast thành công
///      + Điều hướng sang HomePage
///
///  CÔNG NGHỆ & THƯ VIỆN:
///  - Riverpod: registerTrialNotifierProvider để quản lý state đăng ký
///  - ScreenUtil: responsive theo kích thước màn hình
///  - AppLanguage + AppStrings: hỗ trợ đa ngôn ngữ
///  - custom_toast: hiển thị toast báo lỗi/thành công
/// ===========================================================================
class RegisterTrialPage extends ConsumerStatefulWidget {
  const RegisterTrialPage({super.key});

  @override
  ConsumerState<RegisterTrialPage> createState() => _RegisterTrialPageState();
}

class _RegisterTrialPageState extends ConsumerState<RegisterTrialPage> {
  /// Key để validate form (họ tên, số email, khối lớp)
  final _formKey = GlobalKey<FormState>();

  /// Controller cho ô nhập Họ và tên
  final _nameController = TextEditingController();

  /// Controller cho ô nhập Số điện thoại
  final _phoneController = TextEditingController();
  /// Controller cho ô nhập Email
  final _emailController = TextEditingController();
  /// Controller cho ô nhập account
  final _accountController = TextEditingController();
  /// Controller cho ô nhập Số điện thoại
  final _passwordController = TextEditingController();
  /// Cờ cho biết người đăng ký là phụ huynh hay học sinh
  /// (Hiện đang mặc định true = phụ huynh, chưa có UI toggle)

  /// ------------------- Ô PASSWORD (có ẩn/hiện) -------------------
  bool _obscurePassword = true; // thêm biến này ở đầu State class
  /// Giá trị khối lớp đang chọn (Dropdown)
  String? _selectedusername;

  /// Danh sách khối lớp cho Dropdown
  final List<String> _usernames = [
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// State hiện tại của luồng đăng ký (isLoading, success, error)
    final state = ref.watch(registerTrialNotifierProvider);

    /// Lấy ngôn ngữ hiện tại, bọc vào AppStrings để dùng text đa ngôn ngữ
    final appLang = ref.watch(appLanguageProvider);
    final strings = AppStrings(appLang);

    /// Lấy theme hiện tại của app
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // ================================================================
    // LẮNG NGHE THAY ĐỔI STATE ĐĂNG KÝ:
    //  - Thành công: show toast + chuyển sang HomePage
    //  - Thất bại: show toast lỗi
    // ================================================================
    ref.listen(registerTrialNotifierProvider, (previous, next) {
      // Khi đăng ký thành công và không còn loading
      if (next.success && !next.isLoading) {
        showSuccessToast(
          context,
          strings.registerTrialSuccess, // "Đăng ký học thử thành công"
          position: ToastPosition.top,
        );

        // Điều hướng sang HomePage, thay thế màn hiện tại
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }

      // Nếu có lỗi → show toast lỗi
      if (next.error != null && next.error!.isNotEmpty) {
        showErrorToast(
          context,
          next.error!,
          position: ToastPosition.top,
        );
      }
    });

    return Scaffold(
      /// AppBar với nút back + tiêu đề + chọn ngôn ngữ
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18.sp),
          onPressed: () => Navigator.pop(context), // quay lại màn trước (Login)
        ),
        centerTitle: true,
        title: Text(
          strings.registerTrialTitle, // "Đăng ký học thử"
          style: textTheme.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          /// Component chọn ngôn ngữ nằm góc phải AppBar
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: SelectLanguage(),
          ),
        ],
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          /// Padding cho toàn bộ nội dung body
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // =====================================================
              // PHẦN TRÊN: TIÊU ĐỀ + FORM ĐĂNG KÝ
              // =====================================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  12.h.verticalSpace,

                  /// Câu hỏi "Bạn là ai?" or tương tự (whoAreYou)
                  Text(
                    strings.whoAreYou,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  24.h.verticalSpace,

                  /// ==================== FORM ĐĂNG KÝ ====================
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// ------------------- Ô HỌ VÀ TÊN -------------------
                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.fullNameLabel,
                            // "Họ và tên"
                            hintText: strings.fullNameHint,
                            // gợi ý nhập tên
                            labelStyle: TextStyle(fontSize: 13.sp),
                            hintStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            // giảm chiều cao ô nhập
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                          // Kiểm tra họ tên không được để trống
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.fullNameRequired
                              : null,
                        ),

                        24.h.verticalSpace,

                        /// ------------------- Ô SỐ ĐIỆN THOẠI -------------------
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.phoneLabel,
                            // "Số điện thoại"
                            hintText: strings.phoneHint,
                            labelStyle: TextStyle(fontSize: 13.sp),
                            hintStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                          // Kiểm tra email không được trống (logic validate cụ thể ở tầng khác nếu cần)
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.phoneRequired
                              : null,
                        ),

                        24.h.verticalSpace,

                        /// ------------------- Ô EMAIL -------------------
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.emailLabel,
                            // "Số điện thoại"
                            hintText: strings.emailHint,
                            labelStyle: TextStyle(fontSize: 13.sp),
                            hintStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                          // Kiểm tra email không được trống (logic validate cụ thể ở tầng khác nếu cần)
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.emailRequired
                              : null,
                        ),

                        24.h.verticalSpace,


                        /// ------------------- Ô ACCOUNT -------------------
                        TextFormField(
                          controller: _accountController,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.accountLabel,
                            // "Số điện thoại"
                            hintText: strings.accountHint,
                            labelStyle: TextStyle(fontSize: 13.sp),
                            hintStyle: TextStyle(fontSize: 13.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                          ),
                          // Kiểm tra email không được trống (logic validate cụ thể ở tầng khác nếu cần)
                          validator: (v) => (v == null || v.isEmpty)
                              ? strings.accountRequired
                              : null,
                        ),

                        24.h.verticalSpace,

                        /// ------------------- Ô PASSWORD -------------------
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,                // <-- QUAN TRỌNG
                          keyboardType: TextInputType.visiblePassword,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            labelText: strings.passwordLabel,
                            labelStyle: TextStyle(fontSize: 13.sp),
                            hintStyle: TextStyle(fontSize: 13.sp),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),

                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),

                            // ====================== ICON ẨN / HIỆN ======================
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
                          ),

                          validator: (v) =>
                          (v == null || v.isEmpty) ? strings.passwordRequired : null,
                        ),

                        24.h.verticalSpace,



                        /// ------------------- NÚT ĐĂNG KÝ" -------------------
                        SizedBox(
                          width: double.infinity,
                          height: 46.h,
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null // nếu đang loading → disable nút
                                : () {
                                    // Validate form
                                    if (!(_formKey.currentState?.validate() ??
                                        false)) {
                                      return;
                                    }

                                    // Kiểm tra lại khối lớp (phòng trường hợp null)
                                    if (_selectedusername == null) {
                                      showErrorToast(
                                        context,
                                        strings.usernameRequired,
                                        position: ToastPosition.top,
                                      );
                                      return;
                                    }

                                    /// Gọi hàm register trong RegisterTrialNotifier
                                    ref
                                        .read(
                                          registerTrialNotifierProvider
                                              .notifier,
                                        )
                                        .register(
                                          hoten: _nameController.text.trim(),
                                          dienthoai:
                                              _phoneController.text.trim(),
                                          email: _emailController.text.trim(),
                                          username:
                                              _accountController.text.trim()!,
                                      password:
                                              _passwordController.text.trim()!,
                                        );
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
                                    strings.registerButton,
                                    style: textTheme.labelLarge?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),


                        // =====================================================
                        // PHẦN DƯỚI: MÔ TẢ + LINK "Đăng nhập tại đây"
                        // =====================================================
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            24.h.verticalSpace,
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                /// Đoạn text mô tả ngắn về đăng ký học thử
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

                                /// Text "Đăng nhập tại đây" → quay về màn Login
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context); // quay về Login
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
                      ],
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
