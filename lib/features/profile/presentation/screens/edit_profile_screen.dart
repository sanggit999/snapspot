import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/core/widgets/app_avatar.dart';

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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: Text(context.tr('capture_photo')),
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
                      SnackBar(content: Text('Lỗi khi mở camera: $e')),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: Text(context.tr('gallery')),
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
                      SnackBar(content: Text('Lỗi khi mở thư viện: $e')),
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
        context.pop(); // Quay lại màn hình Settings
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
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
                                  ? Colors.grey[850]!
                                  : Colors.grey[200]!,
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
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary,
                              child: const Icon(
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
                  const SizedBox(height: 32),

                  // 2. Ô nhập Họ và Tên
                  _buildLabel(context, context.tr('fullname')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
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
                  const SizedBox(height: 20),

                  // 3. Ô nhập Tên người dùng
                  _buildLabel(context, context.tr('username')),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameController,
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
                  const SizedBox(height: 20),

                  // 4. Ô nhập Tiểu sử (Bio)
                  _buildLabel(context, 'Bio'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _bioController,
                    maxLines: 3,
                    maxLength: 150,
                    decoration: _buildInputDecoration(
                      context,
                      context.tr('bio_hint'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 5. Cài đặt Quyền riêng tư
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.grey[50],
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.tr('private'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                context.tr('private_description'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
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
                  const SizedBox(height: 36),

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
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String hint) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[850]! : Colors.grey[200]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}
