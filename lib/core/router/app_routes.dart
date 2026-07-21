/// Định nghĩa tất cả Hằng số Tuyến đường (Route Paths & Route Names) trong ứng dụng SnapSpot.
///
/// Chuẩn hóa Senior Architecture: Tránh gõ nhầm chuỗi (String Literals) rải rác trong codebase
/// và hỗ trợ các helper method tạo URL truyền tham số an toàn.
abstract class AppRoutes {
  AppRoutes._(); // Private constructor ngăn việc tạo instance

  // ── 1. Auth Routes (Nằm ngoài ShellRoute) ──────────────────────────────────
  static const String login = '/login';
  static const String loginName = 'login';

  static const String register = '/register';
  static const String registerName = 'register';

  // ── 2. Fullscreen / Root Routes (Không có BottomBar) ──────────────────────
  static const String postDetail = '/post/:id';
  static const String postDetailAlias = '/p/:id';
  static const String postDetailName = 'postDetail';

  static const String cameraEditor = '/camera/editor';
  static const String cameraEditorName = 'cameraEditor';

  static const String chatRoom = '/chat/:roomId';
  static const String chatRoomName = 'chatRoom';

  static const String settings = '/settings';
  static const String settingsName = 'settings';

  static const String editProfile = '/edit-profile';
  static const String editProfileName = 'editProfile';

  static const String changePassword = '/change-password';
  static const String changePasswordName = 'changePassword';

  // ── 3. Shell (Main Tabs) Routes (Có BottomBar) ────────────────────────────
  static const String home = '/';
  static const String homeName = 'home';

  static const String explore = '/explore';
  static const String exploreName = 'explore';

  static const String camera = '/camera';
  static const String cameraName = 'camera';

  static const String chat = '/chat';
  static const String chatName = 'chat';

  static const String profile = '/profile';
  static const String profileName = 'profile';

  static const String userProfile = '/user/profile/:id';
  static const String userProfileAlias1 = '/profile/:id';
  static const String userProfileAlias2 = '/user/:id';
  static const String userProfileAlias3 = '/u/:id';
  static const String userProfileName = 'userProfile';

  static const String saved = '/saved';
  static const String savedName = 'saved';

  static const String bookmarks = '/bookmarks';
  static const String bookmarksName = 'bookmarks';

  // ── 4. Helper Methods (Path Generators) ──────────────────────────────────

  /// Đường dẫn màn hình chi tiết bài viết với query param focusComment tùy chọn
  static String postDetailPath(String id, {bool focusComment = false}) {
    if (focusComment) {
      return '/post/$id?focusComment=true';
    }
    return '/post/$id';
  }

  /// Đường dẫn màn hình chỉnh sửa bài đăng sau khi chụp ảnh
  static String cameraEditorPath(String imagePath) {
    final encoded = Uri.encodeComponent(imagePath);
    return '/camera/editor?imagePath=$encoded';
  }

  /// Đường dẫn chi tiết phòng chat
  static String chatRoomPath(String roomId) {
    return '/chat/$roomId';
  }

  /// Đường dẫn trang cá nhân của người dùng bất kỳ
  static String userProfilePath(String userId) {
    return '/user/profile/$userId';
  }
}
