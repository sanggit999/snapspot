import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';

/// Màn hình Chỉnh sửa thông tin cá nhân (Edit Profile Screen) chuẩn Type Scale UI/UX.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late bool _isPrivate;
  String? _selectedAvatarPath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      _fullNameController = TextEditingController(
        text: authState.currentUser.fullName,
      );
      _usernameController = TextEditingController(
        text: authState.currentUser.username,
      );
      _bioController = TextEditingController(text: authState.currentUser.bio);
      _isPrivate = authState.currentUser.isPrivate;
    } else {
      _fullNameController = TextEditingController();
      _usernameController = TextEditingController();
      _bioController = TextEditingController();
      _isPrivate = false;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                title: Text(context.tr('capture_photo'), style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _selectedAvatarPath = image.path;
                      });
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${context.tr('camera_error')}: $e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                title: Text(context.tr('gallery'), style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  try {
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _selectedAvatarPath = image.path;
                      });
                    }
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${context.tr('gallery_error')}: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final success = await context.read<AuthCubit>().updateUserProfile(
      fullName: _fullNameController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      isPrivate: _isPrivate,
      avatarUrl: _selectedAvatarPath,
    );

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr('success'))));
        context.pop();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr('error'))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;

    if (authState is! AuthSuccess) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final user = authState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('edit_profile'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17.5,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Avatar chọn ảnh lớn
                Center(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            width: 4,
                          ),
                        ),
                        child: AppAvatar(
                          imageUrl: _selectedAvatarPath ?? user.avatarUrl,
                          size: AppAvatarSize.large,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Ô nhập Họ và Tên
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6.0,
                  children: [
                    _buildLabel(context, context.tr('fullname')),
                    TextFormField(
                      controller: _fullNameController,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        context,
                        context.tr('enter_fullname'),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return context.tr('fullname_required');
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // 3. Ô nhập Tên người dùng
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6.0,
                  children: [
                    _buildLabel(context, context.tr('username')),
                    TextFormField(
                      controller: _usernameController,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        context,
                        context.tr('username'),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return context.tr('username_required');
                        }
                        if (val.trim().length < 3) {
                          return context.tr('username_too_short');
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                // 4. Ô nhập Tiểu sử (Bio)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6.0,
                  children: [
                    _buildLabel(context, 'Bio'),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 3,
                      maxLength: 150,
                      style: TextStyle(
                        fontSize: 14.5,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                      ),
                      decoration: _buildInputDecoration(
                        context,
                        context.tr('bio_hint'),
                      ),
                    ),
                  ],
                ),

                // 5. Cài đặt Quyền riêng tư
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : Colors.grey[50],
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2.0,
                          children: [
                            Text(
                              context.tr('private'),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                              ),
                            ),
                            Text(
                              context.tr('private_description'),
                              style: TextStyle(
                                fontSize: 12.0,
                                color: isDark
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLightSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isPrivate,
                        activeTrackColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _isPrivate = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // 6. Nút Lưu Thay Đổi
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          context.tr('save_changes'),
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
        fontSize: 14.0,
      ),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
