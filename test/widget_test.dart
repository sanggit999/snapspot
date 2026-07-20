import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snapspot/core/widgets/images/app_avatar.dart';

void main() {
  testWidgets('AppAvatar smoke test', (WidgetTester tester) async {
    // Build AppAvatar and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppAvatar(
            imageUrl: '',
            size: AppAvatarSize.medium,
          ),
        ),
      ),
    );

    // Xác nhận icon placeholder đại diện người dùng được hiển thị khi URL rỗng.
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });
}
