import 'package:flutter/material.dart';

/// Lớp tiện ích cung cấp bản dịch đa ngôn ngữ cho SnapSpot.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('vi'));
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      // Auth
      'login': 'Đăng nhập',
      'register': 'Đăng ký',
      'email': 'Email',
      'password': 'Mật khẩu',
      'username': 'Tên người dùng',
      'confirm_password': 'Nhập lại mật khẩu',
      'enter_email': 'Nhập email của bạn',
      'enter_password': 'Nhập mật khẩu của bạn',
      'forgot_password': 'Quên mật khẩu?',
      'dont_have_account': 'Chưa có tài khoản? Đăng ký',
      'have_account': 'Đã có tài khoản? Đăng nhập',
      'or_continue_with': 'Hoặc tiếp tục bằng',
      'email_required': 'Vui lòng nhập Email',
      'email_invalid': 'Email không đúng định dạng',
      'password_required': 'Vui lòng nhập mật khẩu',
      'password_too_short': 'Mật khẩu phải từ 6 ký tự trở lên',
      'passwords_do_not_match': 'Mật khẩu nhập lại không khớp',
      'username_required': 'Vui lòng nhập tên người dùng',
      'check_email_to_verify':
          'Vui lòng kiểm tra hộp thư để xác thực tài khoản!',

      // Common & Navigation
      'home': 'Trang chủ',
      'explore': 'Khám phá',
      'camera': 'Đăng ảnh',
      'chat': 'Tin nhắn',
      'profile': 'Cá nhân',
      'settings': 'Cài đặt',
      'success': 'Thành công',
      'error': 'Lỗi',
      'loading': 'Đang tải...',

      // Feed
      'tab_follow': 'Theo dõi',
      'tab_nearby': 'Lân cận',
      'distance_away': 'Cách bạn {distance} km',
      'likes': 'lượt thích',
      'comments': 'bình luận',
      'double_tap_to_like': 'Nhấp đúp để thích bài viết',
      'write_a_comment': 'Viết bình luận...',
      'post': 'Đăng',
      'no_posts_found': 'Không tìm thấy bài viết nào.',
      'post_detail': 'Chi tiết bài viết',

      // Map
      'search_places_or_tags': 'Tìm địa điểm hoặc #hashtag...',
      'spot_preview': 'Xem địa điểm',
      'spots_in_area': 'Tìm thấy {count} địa điểm trong khu vực này',
      'choose_location': 'Chọn vị trí trên bản đồ',

      // Camera & Posting
      'capture_photo': 'Chụp ảnh',
      'gallery': 'Thư viện',
      'camera_permission': 'Cần quyền truy cập máy ảnh',
      'post_editor': 'Biên tập bài viết',
      'write_caption': 'Viết mô tả ngắn (caption)...',
      'add_hashtags': 'Thêm hashtag (ví dụ: #dulich #phuot)...',
      'gps_detected': 'Đã tự động đọc tọa độ GPS từ ảnh!',
      'gps_not_detected': 'Không tìm thấy GPS. Hãy chọn vị trí thủ công.',
      'location_tagged': 'Vị trí: {location}',
      'share': 'Chia sẻ bài viết',
      'uploading_in_background': 'Đang tải bài đăng lên nền...',
      'upload_completed': 'Đăng bài thành công!',

      // Chat
      'chat_list': 'Danh sách Chat',
      'no_conversations': 'Chưa có cuộc hội thoại nào.',
      'online': 'Đang hoạt động',
      'type_message': 'Nhập tin nhắn...',
      'simulated_reply': 'Phản hồi giả lập từ đối phương',

      // Profile
      'posts_count': 'Bài viết',
      'followers_count': 'Người theo dõi',
      'following_count': 'Đang theo dõi',
      'account_type': 'Loại tài khoản',
      'public': 'Công khai',
      'private': 'Riêng tư',
      'theme_mode': 'Giao diện',
      'language': 'Ngôn ngữ',
      'light_theme': 'Chế độ Sáng',
      'dark_theme': 'Chế độ Tối',
      'system_theme': 'Theo Hệ thống',
      'logout_confirm': 'Bạn có chắc chắn muốn đăng xuất?',
      'cancel': 'Hủy',

      // Settings Sections
      'section_app_settings': 'CÀI ĐẶT ỨNG DỤNG',
      'section_account_security': 'TÀI KHOẢN & BẢO MẬT',
      'section_support_info': 'HỖ TRỢ & THÔNG TIN',

      // Settings Items
      'edit_profile': 'Chỉnh sửa thông tin',
      'change_password': 'Đổi mật khẩu',
      'notification_settings': 'Cài đặt thông báo',
      'help_feedback': 'Trợ giúp & Phản hồi',
      'privacy_policy': 'Chính sách bảo mật',

      // Edit Profile
      'fullname': 'Họ và tên',
      'enter_fullname': 'Nhập họ và tên',
      'fullname_required': 'Họ tên không được để trống',
      'username_too_short': 'Tên người dùng quá ngắn',
      'bio_hint': 'Nhập vài dòng giới thiệu bản thân...',
      'private_description': 'Chỉ cho phép bạn bè xem bài viết của bạn.',
      'save_changes': 'Lưu thay đổi',
      'avatar_update_hint': 'Tính năng tải ảnh đại diện mới đang được phát triển.',
    },
    'en': {
      // Auth
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'username': 'Username',
      'confirm_password': 'Confirm Password',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': "Don't have an account? Register",
      'have_account': 'Already have an account? Login',
      'or_continue_with': 'Or continue with',
      'email_required': 'Email is required',
      'email_invalid': 'Invalid email format',
      'password_required': 'Password is required',
      'password_too_short': 'Password must be at least 6 characters',
      'passwords_do_not_match': 'Passwords do not match',
      'username_required': 'Username is required',
      'check_email_to_verify':
          'Please check your email box to verify your account!',

      // Common & Navigation
      'home': 'Home',
      'explore': 'Explore',
      'camera': 'Camera',
      'chat': 'Chat',
      'profile': 'Profile',
      'settings': 'Settings',
      'success': 'Success',
      'error': 'Error',
      'loading': 'Loading...',

      // Feed
      'tab_follow': 'Following',
      'tab_nearby': 'Nearby',
      'distance_away': '{distance} km away',
      'likes': 'likes',
      'comments': 'comments',
      'double_tap_to_like': 'Double-tap to like post',
      'write_a_comment': 'Write a comment...',
      'post': 'Post',
      'no_posts_found': 'No posts found.',
      'post_detail': 'Post Detail',

      // Map
      'search_places_or_tags': 'Search locations or #tags...',
      'spot_preview': 'Preview Spot',
      'spots_in_area': 'Found {count} spots in this area',
      'choose_location': 'Choose location on map',

      // Camera & Posting
      'capture_photo': 'Take Photo',
      'gallery': 'Gallery',
      'camera_permission': 'Camera access required',
      'post_editor': 'Post Editor',
      'write_caption': 'Write a caption...',
      'add_hashtags': 'Add hashtags (e.g. #travel #photography)...',
      'gps_detected': 'GPS coordinates auto-extracted from photo!',
      'gps_not_detected': 'No GPS found. Please select location manually.',
      'location_tagged': 'Location: {location}',
      'share': 'Share Post',
      'uploading_in_background': 'Uploading post in background...',
      'upload_completed': 'Post published successfully!',

      // Chat
      'chat_list': 'Chat List',
      'no_conversations': 'No conversations yet.',
      'online': 'Active now',
      'type_message': 'Type a message...',
      'simulated_reply': 'Simulated reply from partner',

      // Profile
      'posts_count': 'Posts',
      'followers_count': 'Followers',
      'following_count': 'Following',
      'account_type': 'Account Status',
      'public': 'Public',
      'private': 'Private',
      'theme_mode': 'Theme Mode',
      'language': 'Language',
      'light_theme': 'Light Theme',
      'dark_theme': 'Dark Theme',
      'system_theme': 'System Theme',
      'logout': 'Logout',
      'logout_confirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',

      // Settings Sections
      'section_app_settings': 'APP SETTINGS',
      'section_account_security': 'ACCOUNT & SECURITY',
      'section_support_info': 'SUPPORT & INFO',

      // Settings Items
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'notification_settings': 'Notification Settings',
      'help_feedback': 'Help & Feedback',
      'privacy_policy': 'Privacy Policy',

      // Edit Profile
      'fullname': 'Full Name',
      'enter_fullname': 'Enter your full name',
      'fullname_required': 'Full name cannot be empty',
      'username_too_short': 'Username is too short',
      'bio_hint': 'Tell us a bit about yourself...',
      'private_description': 'Only allow friends to view your posts.',
      'save_changes': 'Save changes',
      'avatar_update_hint': 'Profile image upload feature is under development.',
    },
  };

  /// Lấy bản dịch dựa trên khóa và tham số động.
  String translate(String key, {Map<String, String>? arguments}) {
    final values = _localizedValues[locale.languageCode];
    if (values == null) return key;

    String value = values[key] ?? key;

    if (arguments != null) {
      arguments.forEach((argKey, argValue) {
        value = value.replaceAll('{$argKey}', argValue);
      });
    }

    return value;
  }
}

/// Helper Extension trên BuildContext để dịch nhanh gọn trong widget tree.
extension AppLocalizationsExtension on BuildContext {
  String tr(String key, {Map<String, String>? args}) {
    return AppLocalizations.of(this).translate(key, arguments: args);
  }
}

/// Delegate để tích hợp vào MaterialApp.localizationsDelegates
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['vi', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
