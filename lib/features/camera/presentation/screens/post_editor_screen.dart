import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/camera/presentation/blocs/post_editor_cubit.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';

/// Màn hình Biên tập bài viết (Post Editor Screen) chuẩn Type Scale & High-Contrast Light/Dark Mode.
class PostEditorScreen extends StatefulWidget {
  final String imagePath;
  const PostEditorScreen({super.key, required this.imagePath});

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final _captionController = TextEditingController();
  final _hashtagController = TextEditingController();

  late String _locationName;
  late double _latitude;
  late double _longitude;
  bool _hasGps = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final uri = GoRouterState.of(context).uri;
    _locationName = uri.queryParameters['location'] ?? 'Vị trí chưa xác định';
    _latitude =
        double.tryParse(uri.queryParameters['lat'] ?? '10.7769') ?? 10.7769;
    _longitude =
        double.tryParse(uri.queryParameters['lng'] ?? '106.7009') ?? 106.7009;
    _hasGps = uri.queryParameters['lat'] != null;
  }

  @override
  void dispose() {
    _captionController.dispose();
    _hashtagController.dispose();
    super.dispose();
  }

  void _onSharePressed() {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthSuccess) return;

    final List<String> hashtags = _hashtagController.text
        .split(' ')
        .where((tag) => tag.startsWith('#'))
        .map((tag) => tag.replaceAll('#', ''))
        .toList();

    context.read<PostEditorCubit>().uploadPost(
      caption: _captionController.text,
      imageUrls: [widget.imagePath],
      latitude: _latitude,
      longitude: _longitude,
      locationName: _locationName,
      currentUser: authState.currentUser,
      hashtags: hashtags,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('post_editor'),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 17.5,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
            letterSpacing: -0.3,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 19,
            color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        elevation: 0,
        backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
        actions: [
          TextButton(
            onPressed: _onSharePressed,
            child: Text(
              context.tr('share'),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<PostEditorCubit, PostEditorState>(
        listener: (context, state) {
          if (state is PostEditorSuccess) {
            context.read<FeedCubit>().addNewPost(state.createdPost);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('upload_completed')),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/');
            context.read<PostEditorCubit>().reset();
          }
        },
        builder: (context, state) {
          if (state is PostEditorUploading) {
            return _buildUploadProgress(state.progress, isLight);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Xem trước ảnh chọn
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(widget.imagePath, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Trích xuất GPS metadata banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _hasGps
                        ? AppColors.success.withValues(alpha: 0.08)
                        : AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _hasGps
                          ? AppColors.success.withValues(alpha: 0.3)
                          : AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _hasGps ? Icons.gps_fixed : Icons.gps_off,
                        color: _hasGps ? AppColors.success : AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _hasGps
                              ? context.tr('gps_detected')
                              : context.tr('gps_not_detected'),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.0,
                            color: _hasGps
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Caption input
                TextField(
                  controller: _captionController,
                  maxLines: 4,
                  maxLength: 500,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: context.tr('write_caption'),
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                    ),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isLight ? AppColors.borderLight : AppColors.borderDark,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isLight ? AppColors.borderLight : AppColors.borderDark,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Hashtag input
                TextField(
                  controller: _hashtagController,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: context.tr('add_hashtags'),
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                    ),
                    prefixIcon: const Icon(Icons.tag, size: 20, color: AppColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isLight ? AppColors.borderLight : AppColors.borderDark,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isLight ? AppColors.borderLight : AppColors.borderDark,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Bản đồ mini hiển thị vị trí ghim
                Text(
                  context.tr('post_location_map'),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                    color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isLight ? AppColors.borderLight : AppColors.borderDark,
                    ),
                    color: isLight ? Colors.grey[100] : AppColors.surfaceDark,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: GridPaper(
                            color: isLight ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                            size: 36,
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              _locationName,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.0,
                                color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'GPS: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isLight ? AppColors.textLightSecondary : AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: isLight ? Colors.white : AppColors.surfaceDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                          ),
                          icon: const Icon(Icons.map, size: 14, color: AppColors.primary),
                          label: Text(
                            context.tr('choose_location'),
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUploadProgress(double progress, bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: AppColors.primary,
              strokeWidth: 6,
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('uploading_in_background'),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: isLight ? AppColors.textLightPrimary : AppColors.textDarkPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
