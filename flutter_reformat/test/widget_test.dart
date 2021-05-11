// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_reformat/main.dart';

void main() {
  testWidgets('NotificationListpage check UI and tap event',
      (WidgetTester tester) async {
    var api = await MockAPIService.make(mockOperation: (api) {
      final Map<String, dynamic> data = json.decode(sourceStringForTitleString);
      api.setMockCGIData(CGI.notify_list, data);
    });
    HttpOverrides.runZoned<Future<void>>(() async {
      await tester.pumpWidget(
          MockTencentDocsApp(initialRoute: "/NotificationListPage", api: api));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await api.getNotificationService().reloadList();
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      Finder widgetFinder = find.byKey(Key('dropDownTitle'));
      Finder rtFinder =
          find.descendant(of: widgetFinder, matching: find.byType(RichText));
      RichText richText = rtFinder.evaluate().first.widget as RichText;
      String richTextText = richText.text.toPlainText();

      print('Text from Text widget: $richTextText');
      expect(richTextText, 'Ripley  申请可编辑权限￼',
          reason: 'Text from found text widget do not match');

      final isTapped = !richText.text.visitChildren(
        (visitor) => findTextAndTap(visitor, '可编辑权限'),
      );
    }, createHttpClient: createMockImageHttpClient);
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
