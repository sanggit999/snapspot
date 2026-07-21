import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

/// Dịch vụ Chia sẻ trực tiếp trỏ vào các ứng dụng di động Android & iOS.
/// Hỗ trợ Deep Link trỏ thẳng App Zalo, Messenger, Facebook và System Native Share Sheet.
class AppShareService {
  const AppShareService._();

  /// 1. Chia sẻ qua Zalo (Trỏ trực tiếp App Zalo hoặc Zalo Web Share API)
  static Future<void> shareToZalo({
    required String postUrl,
    required String title,
  }) async {
    final encodedUrl = Uri.encodeComponent(postUrl);
    final encodedTitle = Uri.encodeComponent(title);

    final zaloAppUri = Uri.parse('zalo://share?url=$encodedUrl&text=$encodedTitle');
    final zaloWebUri = Uri.parse('https://zalo.me/share?url=$encodedUrl&text=$encodedTitle');

    try {
      if (await canLaunchUrl(zaloAppUri)) {
        await launchUrl(zaloAppUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(zaloWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(zaloWebUri, mode: LaunchMode.externalApplication);
    }
  }

  /// 2. Chia sẻ qua Facebook Messenger (Trỏ trực tiếp Messenger App hoặc Web)
  static Future<void> shareToMessenger({
    required String postUrl,
  }) async {
    final encodedUrl = Uri.encodeComponent(postUrl);
    final messengerAppUri = Uri.parse('fb-messenger://share/?link=$encodedUrl');
    final messengerWebUri = Uri.parse('https://www.facebook.com/dialog/send?link=$encodedUrl&app_id=123456789&redirect_uri=$encodedUrl');

    try {
      if (await canLaunchUrl(messengerAppUri)) {
        await launchUrl(messengerAppUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(messengerWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(messengerWebUri, mode: LaunchMode.externalApplication);
    }
  }

  /// 3. Chia sẻ lên Facebook (Trỏ trực tiếp Facebook App hoặc Web Sharer)
  static Future<void> shareToFacebook({
    required String postUrl,
  }) async {
    final encodedUrl = Uri.encodeComponent(postUrl);
    final fbAppUri = Uri.parse('fb://facewebmodal/f?href=https://www.facebook.com/sharer/sharer.php?u=$encodedUrl');
    final fbWebUri = Uri.parse('https://www.facebook.com/sharer/sharer.php?u=$encodedUrl');

    try {
      if (await canLaunchUrl(fbAppUri)) {
        await launchUrl(fbAppUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(fbWebUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(fbWebUri, mode: LaunchMode.externalApplication);
    }
  }

  /// 4. Mở Native System Share Sheet của hệ điều hành iOS / Android
  static Future<void> shareToSystem({
    required String postUrl,
    required String title,
  }) async {
    await Share.share(
      '$title\nXem chi tiết địa điểm check-in tại: $postUrl',
      subject: title,
    );
  }
}
