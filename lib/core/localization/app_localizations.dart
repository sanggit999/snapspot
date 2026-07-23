import 'package:flutter/material.dart';

/// Lớp tiện ích cung cấp bản dịch đa ngôn ngữ cho SnapSpot.
/// Đảm bảo viết hoa chữ cái đầu (Title Case / Sentence Case) và thuật ngữ Tiếng Việt chuẩn xác 100%.
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
      'create_account': 'Tạo tài khoản mới',
      'register_subtitle': 'Đăng ký để khám phá các địa điểm check-in hấp dẫn',
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
      'email_required': 'Vui lòng nhập email',
      'email_invalid': 'Email không đúng định dạng',
      'password_required': 'Vui lòng nhập mật khẩu',
      'password_too_short': 'Mật khẩu phải từ 6 ký tự trở lên',
      'passwords_do_not_match': 'Mật khẩu nhập lại không khớp',
      'username_required': 'Vui lòng nhập tên người dùng',
      'app_slogan': 'Ghim khoảnh khắc, chia sẻ bản đồ',
      'email_or_username': 'Email hoặc Tên người dùng',
      'enter_email_or_username': 'Nhập Email hoặc Tên người dùng...',
      'email_or_username_required': 'Vui lòng nhập Email hoặc Tên người dùng',
      'check_email_to_verify':
          'Vui lòng kiểm tra hộp thư để xác thực tài khoản!',
      'no_internet_connection': 'Không có kết nối Internet',
      'back_online': 'Đã kết nối lại Internet',

      // Common & Navigation
      'home': 'Trang chủ',
      'explore': 'Khám phá',
      'camera': 'Chụp ảnh',
      'chat': 'Tin nhắn',
      'profile': 'Trang cá nhân',
      'settings': 'Cài đặt',
      'success': 'Thành công',
      'error': 'Lỗi',
      'loading': 'Đang tải...',
      'logout': 'Đăng xuất',
      'camera_error': 'Lỗi khi mở máy ảnh',
      'gallery_error': 'Lỗi khi mở thư viện ảnh',
      'app_version': 'Phiên bản 1.2.0 (Build 2026)',
      'all': 'Tất cả',
      'edit': 'Chỉnh sửa',
      'share_profile': 'Chia sẻ trang',
      'profile_link_copied': 'Đã sao chép liên kết trang cá nhân @{username}!',
      'followed_user': 'Đã theo dõi @{username}',
      'unfollowed_user': 'Đã bỏ theo dõi @{username}',
      'following': 'Đang theo dõi',
      'follow': 'Theo dõi',
      'message': 'Nhắn tin',
      'all_folders': 'Tất cả thư mục',
      'filtering_by': 'Đang lọc: {name}',
      'saved_posts_count': '{count} bài lưu',
      'create_first_collection': 'Tạo bộ sưu tập đầu tiên',
      'collection_empty_hint': 'Gom nhóm bài viết đã lưu theo chủ đề yêu thích của bạn.',
      'quick_presets_title': 'Gợi ý chủ đề nhanh:',
      'preset_cafe_label': 'Cà phê & Chill',
      'preset_cafe_name': 'Quán cà phê đẹp',
      'preset_travel_label': 'Đi phượt & Du lịch',
      'preset_travel_name': 'Đi phượt & Du lịch',
      'preset_photo_label': 'Góc chụp đẹp',
      'preset_photo_name': 'Góc chụp ảnh đẹp',
      'preset_places_label': 'Địa điểm muốn đến',
      'preset_places_name': 'Địa điểm muốn đến',
      'preset_favorites_label': 'Yêu thích',
      'preset_favorites_name': 'Địa điểm yêu thích',
      'create_collection_title': 'Tạo bộ sưu tập mới',
      'edit_collection_title': 'Chỉnh sửa bộ sưu tập',
      'collection_name': 'Tên bộ sưu tập',
      'collection_name_hint': 'Ví dụ: Quán cà phê chill, Điểm check-in...',
      'collection_name_required': 'Vui lòng nhập tên bộ sưu tập',
      'collection_icon': 'Biểu tượng đại diện',
      'collection_color': 'Màu chủ đề',
      'private_collection': 'Bộ sưu tập riêng tư',
      'private_collection_desc': 'Chỉ có bạn mới xem được các bài đăng trong bộ sưu tập này.',
      'create_collection_btn': 'Tạo bộ sưu tập',
      'delete_collection_title': 'Xóa bộ sưu tập',
      'delete_collection_confirm': 'Bạn có chắc chắn muốn xóa bộ sưu tập "{name}"? Tất cả bài viết trong thư mục này sẽ được tự động chuyển về mục Tất cả.',
      'deleted_collection_msg': 'Đã xóa bộ sưu tập "{name}"',
      'delete_action': 'Xóa',
      'create_new': 'Tạo mới',
      'collection_label': 'Bộ sưu tập',
      'explore_icons': 'Kho biểu tượng',
      'custom_color': 'Màu tùy chỉnh',
      'custom_color_btn': 'Kho màu sắc',
      'color_palette': 'Kho màu sắc',
      'enter_hex_color': 'Nhập mã màu Hex (VD: #E91E63)',
      'invalid_hex_color': 'Mã màu Hex không hợp lệ',

      // Feed
      'tab_follow': 'Theo dõi',
      'tab_nearby': 'Lân cận',
      'distance_away': 'Cách bạn {distance} km',
      'distance_from_you': 'Cách bạn',
      'likes': 'Lượt thích',
      'comments': 'Bình luận',
      'double_tap_to_like': 'Nhấp đúp để thích bài viết',
      'write_a_comment': 'Viết bình luận...',
      'post': 'Đăng bài',
      'no_posts_found': 'Không tìm thấy bài viết nào.',
      'post_detail': 'Chi tiết bài viết',
      'my_posts': 'Bài viết của bạn',
      'posts_of_author': 'Bài viết của {name}',
      'view_all_comments': 'Xem tất cả bình luận',
      'no_posts_tagged': 'Chưa có bài viết nào gắn thẻ "#{tag}"',
      'be_the_first_post': 'Hãy là người đầu tiên chụp ảnh & đính kèm thẻ này!',
      'post_now': 'Đăng bài check-in ngay',

      // SpotCard & Collections & Sharing
      'share_post': 'Chia sẻ bài viết',
      'share_external': 'Chia sẻ qua ứng dụng ngoài',
      'copy_link': 'Sao chép liên kết bài viết',
      'link_copied': 'Đã sao chép liên kết vào bộ nhớ tạm!',
      'save_to_collection': 'Lưu vào Bộ sưu tập',
      'remove_from_collection': 'Bỏ lưu khỏi Bộ sưu tập',
      'saved_to_collection': 'Đã lưu bài viết vào bộ sưu tập "{name}"',
      'removed_from_collection': 'Đã bỏ lưu bài viết khỏi bộ sưu tập',
      'quick_send_friends': 'Gửi nhanh cho bạn bè',
      'sent': 'Đã gửi ✓',
      'send': 'Gửi',
      'shares_count': '{count} lượt chia sẻ',
      'reacted_emoji': 'Đã bày tỏ cảm xúc {emoji}',
      'other': 'Khác...',
      'share_story_title': 'Chia sẻ lên Tin của bạn (Story)',
      'share_story_desc': 'Tạo Sticker địa điểm check-in độc đáo',
      'share_external_title': 'Chia sẻ qua Ứng dụng khác',
      'share_external_desc': 'Zalo, Messenger, Facebook, Khác...',
      'cannot_load_image': 'Không thể tải ảnh',

      // Comments Thread
      'pin_comment': 'Ghim bình luận nổi bật',
      'unpin_comment': 'Bỏ ghim bình luận',
      'delete_comment': 'Xóa bình luận',
      'report_comment': 'Báo cáo bình luận này',
      'replying_to': 'Đang trả lời {name} (@{username})',
      'author': 'Tác giả',
      'pinned': 'Đã ghim',

      // Map
      'search_places_or_tags': 'Tìm địa điểm hoặc thẻ #hashtag...',
      'spot_preview': 'Xem địa điểm',
      'spots_in_area': 'Tìm thấy {count} địa điểm trong khu vực này',
      'choose_location': 'Chọn vị trí trên bản đồ',
      'scan_coordinates': 'Quét tọa độ...',
      'post_location_map': 'Bản đồ vị trí bài viết',

      // Camera & Posting
      'capture_photo': 'Chụp ảnh',
      'gallery': 'Thư viện ảnh',
      'camera_permission': 'Cần quyền truy cập máy ảnh',
      'post_editor': 'Biên tập bài viết',
      'write_caption': 'Viết mô tả ngắn (caption)...',
      'add_hashtags': 'Thêm thẻ (ví dụ: #dulich #phuot)...',
      'gps_detected': 'Đã tự động đọc tọa độ GPS từ ảnh!',
      'gps_not_detected': 'Không tìm thấy GPS. Hãy chọn vị trí thủ công.',
      'location_tagged': 'Vị trí: {location}',
      'share': 'Chia sẻ bài viết',
      'uploading_in_background': 'Đang tải bài đăng lên...',
      'upload_completed': 'Đăng bài thành công!',

      // Chat
      'chat_list': 'Danh sách nhắn tin',
      'no_conversations': 'Chưa có cuộc trò chuyện nào.',
      'online': 'Đang hoạt động',
      'type_message': 'Nhập tin nhắn...',
      'simulated_reply': 'Phản hồi tự động từ đối phương',

      // Profile Empty States & Details
      'posts_count': 'Bài viết',
      'followers_count': 'Người theo dõi',
      'following_count': 'Đang theo dõi',
      'account_type': 'Loại tài khoản',
      'public': 'Công khai',
      'private': 'Riêng tư',
      'only_you': 'Chỉ mình bạn',
      'theme_mode': 'Giao diện',
      'language': 'Ngôn ngữ',
      'light_theme': 'Sáng',
      'dark_theme': 'Tối',
      'system_theme': 'Hệ thống',
      'logout_confirm': 'Bạn có chắc chắn muốn đăng xuất tài khoản?',
      'cancel': 'Hủy',
      'your_collections': 'Bộ sưu tập của bạn',
      'no_posts_me': 'Bạn chưa có bài đăng nào.',
      'no_posts_user': '@{username} chưa có bài đăng nào.',
      'no_saved_posts': 'Chưa có bài viết nào được lưu.',
      'no_saved_in_collection': 'Chưa có bài viết nào trong bộ sưu tập "{name}".',
      'no_checkin_user': '@{username} chưa check-in địa điểm nào.',

      // Settings Sections
      'section_app_settings': 'CÀI ĐẶT ỨNG DỤNG',
      'section_account_security': 'TÀI KHOẢN & BẢO MẬT',
      'section_support_info': 'HỖ TRỢ & THÔNG TIN',

      // Settings Items & Modals
      'edit_profile': 'Chỉnh sửa thông tin cá nhân',
      'change_password': 'Đổi mật khẩu',
      'notification_settings': 'Cài đặt thông báo',
      'help_feedback': 'Trợ giúp & Phản hồi',
      'privacy_policy': 'Chính sách bảo mật',
      'push_notifications': 'Thông báo đẩy',
      'email_notifications': 'Thông báo qua email',
      'sound_effects': 'Âm thanh thông báo',
      'vibration': 'Rung phản hồi (Haptic)',
      'send_feedback': 'Gửi phản hồi',
      'feedback_hint': 'Hãy nhập góp ý hoặc báo lỗi tại đây...',
      'feedback_sent': 'Cảm ơn bạn đã gửi phản hồi cho SnapSpot!',
      'privacy_policy_title': 'Chính sách bảo mật dữ liệu',
      'privacy_policy_content':
          'SnapSpot cam kết bảo vệ thông tin vị trí GPS và dữ liệu cá nhân của bạn theo tiêu chuẩn quốc tế ISO 27001. Dữ liệu định vị chỉ được trích xuất khi bạn cho phép và tạo bài đăng check-in.',

      // Edit Profile
      'fullname': 'Họ và tên',
      'enter_fullname': 'Nhập họ và tên',
      'fullname_required': 'Họ và tên không được để trống',
      'username_too_short': 'Tên người dùng quá ngắn',
      'bio_hint': 'Nhập vài dòng giới thiệu bản thân...',
      'private_description': 'Chỉ cho phép bạn bè xem bài viết của bạn.',
      'save_changes': 'Lưu thay đổi',
      'avatar_update_hint': 'Tính năng tải ảnh đại diện mới đang được phát triển.',

      // Change Password
      'current_password_label': 'Mật khẩu hiện tại',
      'current_password_hint': 'Nhập mật khẩu hiện tại của bạn',
      'current_password_required': 'Vui lòng nhập mật khẩu hiện tại',
      'new_password_label': 'Mật khẩu mới',
      'new_password_hint': 'Nhập mật khẩu mới (từ 6 ký tự trở lên)',
      'new_password_required': 'Vui lòng nhập mật khẩu mới',
      'confirm_new_password_label': 'Nhập lại mật khẩu mới',
      'confirm_new_password_hint': 'Nhập lại mật khẩu mới để xác nhận',
      'confirm_new_password_required': 'Vui lòng xác nhận mật khẩu mới',
      'update_password': 'Cập nhật mật khẩu',
    },
    'en': {
      // Auth
      'login': 'Login',
      'register': 'Register',
      'create_account': 'Create New Account',
      'register_subtitle': 'Register to discover amazing check-in spots',
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
      'app_slogan': 'Pin your moments, share the map',
      'email_or_username': 'Email or Username',
      'enter_email_or_username': 'Enter Email or Username...',
      'email_or_username_required': 'Please enter Email or Username',
      'check_email_to_verify':
          'Please check your inbox to verify your account!',
      'no_internet_connection': 'No Internet connection',
      'back_online': 'Back online',

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
      'logout': 'Log Out',
      'camera_error': 'Error opening camera',
      'gallery_error': 'Error opening gallery',
      'app_version': 'Version 1.2.0 (Build 2026)',
      'all': 'All',
      'edit': 'Edit',
      'share_profile': 'Share Profile',
      'profile_link_copied': 'Copied profile link for @{username}!',
      'followed_user': 'Followed @{username}',
      'unfollowed_user': 'Unfollowed @{username}',
      'following': 'Following',
      'follow': 'Follow',
      'message': 'Message',
      'all_folders': 'All Folders',
      'filtering_by': 'Filtering: {name}',
      'saved_posts_count': '{count} saved',
      'create_first_collection': 'Create first collection',
      'collection_empty_hint': 'Group saved posts by your favorite themes.',
      'quick_presets_title': 'Quick Theme Suggestions:',
      'preset_cafe_label': 'Cafes & Chill',
      'preset_cafe_name': 'Beautiful Cafes',
      'preset_travel_label': 'Travel & Adventure',
      'preset_travel_name': 'Travel & Adventure',
      'preset_photo_label': 'Photo Spots',
      'preset_photo_name': 'Best Photo Spots',
      'preset_places_label': 'Places to Visit',
      'preset_places_name': 'Must-visit Places',
      'preset_favorites_label': 'Favorites',
      'preset_favorites_name': 'Favorite Spots',
      'create_collection_title': 'Create New Collection',
      'edit_collection_title': 'Edit Collection',
      'collection_name': 'Collection Name',
      'collection_name_hint': 'e.g. Chill Cafes, Check-in Spots...',
      'collection_name_required': 'Please enter collection name',
      'collection_icon': 'Representing Icon',
      'collection_color': 'Theme Color',
      'private_collection': 'Private Collection',
      'private_collection_desc': 'Only you can view posts in this collection.',
      'create_collection_btn': 'Create Collection',
      'delete_collection_title': 'Delete Collection',
      'delete_collection_confirm': 'Are you sure you want to delete collection "{name}"? All posts in this folder will automatically move to All.',
      'deleted_collection_msg': 'Deleted collection "{name}"',
      'delete_action': 'Delete',
      'create_new': 'Create New',
      'collection_label': 'Collection',
      'explore_icons': 'Icon library',
      'custom_color': 'Custom Color',
      'custom_color_btn': 'Color palette',
      'color_palette': 'Color Palette',
      'enter_hex_color': 'Enter Hex color code (e.g. #E91E63)',
      'invalid_hex_color': 'Invalid Hex color',

      // Feed
      'tab_follow': 'Following',
      'tab_nearby': 'Nearby',
      'distance_away': '{distance} km away',
      'distance_from_you': 'Away from you',
      'likes': 'Likes',
      'comments': 'Comments',
      'double_tap_to_like': 'Double-tap to like post',
      'write_a_comment': 'Write a comment...',
      'post': 'Post',
      'no_posts_found': 'No posts found.',
      'post_detail': 'Post Detail',
      'my_posts': 'Your Posts',
      'posts_of_author': 'Posts by {name}',
      'view_all_comments': 'View all comments',
      'no_posts_tagged': 'No posts tagged with "#{tag}" yet',
      'be_the_first_post': 'Be the first to take a photo & add this tag!',
      'post_now': 'Post check-in now',

      // SpotCard & Collections & Sharing
      'share_post': 'Share Post',
      'share_external': 'Share to external apps',
      'copy_link': 'Copy post link',
      'link_copied': 'Link copied to clipboard!',
      'save_to_collection': 'Save to Collection',
      'remove_from_collection': 'Remove from Collection',
      'saved_to_collection': 'Post saved to collection "{name}"',
      'removed_from_collection': 'Post removed from collection',
      'quick_send_friends': 'Send to friends',
      'sent': 'Sent ✓',
      'send': 'Send',
      'shares_count': '{count} shares',
      'reacted_emoji': 'Reacted with {emoji}',
      'other': 'Other...',
      'share_story_title': 'Share to Your Story',
      'share_story_desc': 'Create unique location check-in sticker',
      'share_external_title': 'Share via Other Apps',
      'share_external_desc': 'Zalo, Messenger, Facebook, Other...',
      'cannot_load_image': 'Failed to load image',

      // Comments Thread
      'pin_comment': 'Pin featured comment',
      'unpin_comment': 'Unpin comment',
      'delete_comment': 'Delete comment',
      'report_comment': 'Report this comment',
      'replying_to': 'Replying to {name} (@{username})',
      'author': 'Author',
      'pinned': 'Pinned',

      // Map
      'search_places_or_tags': 'Search locations or #tags...',
      'spot_preview': 'Preview Spot',
      'spots_in_area': 'Found {count} spots in this area',
      'choose_location': 'Choose location on map',
      'scan_coordinates': 'Scanning coordinates...',
      'post_location_map': 'Post Location Map',

      // Camera & Posting
      'capture_photo': 'Take Photo',
      'gallery': 'Gallery',
      'camera_permission': 'Camera access required',
      'post_editor': 'Post Editor',
      'write_caption': 'Write a caption...',
      'add_hashtags': 'Add tags (e.g. #travel #photography)...',
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

      // Profile Empty States & Details
      'posts_count': 'Posts',
      'followers_count': 'Followers',
      'following_count': 'Following',
      'account_type': 'Account Status',
      'public': 'Public',
      'private': 'Private',
      'only_you': 'Only you',
      'theme_mode': 'Theme Mode',
      'language': 'Language',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'logout_confirm': 'Are you sure you want to log out?',
      'cancel': 'Cancel',
      'your_collections': 'Your Collections',
      'no_posts_me': 'You have no posts yet.',
      'no_posts_user': '@{username} has no posts yet.',
      'no_saved_posts': 'No saved posts found.',
      'no_saved_in_collection': 'No posts saved in collection "{name}".',
      'no_checkin_user': '@{username} has not checked in anywhere yet.',

      // Settings Sections
      'section_app_settings': 'APP SETTINGS',
      'section_account_security': 'ACCOUNT & SECURITY',
      'section_support_info': 'SUPPORT & INFO',

      // Settings Items & Modals
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'notification_settings': 'Notification Settings',
      'help_feedback': 'Help & Feedback',
      'privacy_policy': 'Privacy Policy',
      'push_notifications': 'Push Notifications',
      'email_notifications': 'Email Notifications',
      'sound_effects': 'Notification Sounds',
      'vibration': 'Haptic Feedback',
      'send_feedback': 'Send Feedback',
      'feedback_hint': 'Enter your feedback or bug report here...',
      'feedback_sent': 'Thank you for your feedback to SnapSpot!',
      'privacy_policy_title': 'Data Privacy Policy',
      'privacy_policy_content':
          'SnapSpot is committed to protecting your GPS location and personal data under ISO 27001 international standard. Location data is only extracted when you grant permission and publish check-in posts.',

      // Edit Profile
      'fullname': 'Full Name',
      'enter_fullname': 'Enter your full name',
      'fullname_required': 'Full name cannot be empty',
      'username_too_short': 'Username is too short',
      'bio_hint': 'Tell us a bit about yourself...',
      'private_description': 'Only allow friends to view your posts.',
      'save_changes': 'Save Changes',
      'avatar_update_hint': 'Profile image upload feature is under development.',

      // Change Password
      'current_password_label': 'Current Password',
      'current_password_hint': 'Enter your current password',
      'current_password_required': 'Please enter your current password',
      'new_password_label': 'New Password',
      'new_password_hint': 'Enter new password (min 6 chars)',
      'new_password_required': 'Please enter your new password',
      'confirm_new_password_label': 'Confirm New Password',
      'confirm_new_password_hint': 'Re-enter your new password to confirm',
      'confirm_new_password_required': 'Please confirm your new password',
      'update_password': 'Update Password',
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
