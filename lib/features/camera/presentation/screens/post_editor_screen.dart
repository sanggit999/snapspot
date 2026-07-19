import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:snapspot/core/constants/colors.dart';
import 'package:snapspot/core/localization/app_localizations.dart';
import 'package:snapspot/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:snapspot/features/camera/presentation/blocs/post_editor_cubit.dart';
import 'package:snapspot/features/feed/presentation/blocs/feed_cubit.dart';

/// Màn hình Biên tập bài viết (Post Editor Screen).
/// Đọc dữ liệu GPS giả lập, hỗ trợ nhập caption, thêm hashtag, hiển thị bản đồ mini và upload nền.
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

    // Đọc thông số GPS được truyền qua URI query parameters
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

    // Phân tích hashtags nhập vào
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

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('post_editor')),
        actions: [
          TextButton(
            onPressed: _onSharePressed,
            child: Text(
              context.tr('share'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<PostEditorCubit, PostEditorState>(
        listener: (context, state) {
          if (state is PostEditorSuccess) {
            // Đẩy bài đăng mới vào FeedCubit để hiển thị tức thì trên Home
            context.read<FeedCubit>().addNewPost(state.createdPost);

            // Hiện thông báo và quay lại Trang chủ
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
            return _buildUploadProgress(state.progress);
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
                            fontWeight: FontWeight.bold,
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
                  decoration: InputDecoration(
                    hintText: context.tr('write_caption'),
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Hashtag input
                TextField(
                  controller: _hashtagController,
                  decoration: InputDecoration(
                    hintText: context.tr('add_hashtags'),
                    prefixIcon: const Icon(Icons.tag, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. Bản đồ mini hiển thị vị trí ghim
                const Text(
                  'Bản đồ Vị trí bài viết',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.brightness == Brightness.light
                          ? AppColors.borderLight
                          : AppColors.borderDark,
                    ),
                    color: theme.brightness == Brightness.light
                        ? Colors.grey[200]
                        : Colors.grey[900],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Simulated mini map grid
                      Positioned.fill(
                        child: Opacity(
                          opacity: 0.1,
                          child: GridPaper(
                            color: theme.brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'GPS: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Nút đổi vị trí thủ công
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: TextButton.icon(
                          onPressed: () {
                            // TODO: Chọn lại toạ độ thủ công
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                          ),
                          icon: const Icon(Icons.map, size: 14),
                          label: Text(
                            context.tr('choose_location'),
                            style: const TextStyle(fontSize: 11),
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

  /// Giao diện phần trăm tải lên bất đồng bộ nền
  Widget _buildUploadProgress(double progress) {
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
