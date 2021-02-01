import 'package:TencentDocsApp/widget/ocr/services/ocr_services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return ".";
  });

  test('OCRService check function test: print new path', () async {
    String filePath = path.joinAll(
        [Directory.current.path, 'test', 'unit_test', 'ocr_test_img_1.jpg']);
    String newPath = await OCRService.checkFileSize(filePath, 2000);
    expect(newPath == filePath, false);
  });
  test('OCRService check function test: print new path', () async {
    String filePath = path.joinAll(
        [Directory.current.path, 'test', 'unit_test', 'ocr_test_img_2.jpg']);
    String newPath = await OCRService.checkFileSize(filePath, 2000);
    expect(newPath == filePath, false);
  });
  test('OCRService check function test: retain old path', () async {
    String filePath = path.joinAll(
        [Directory.current.path, 'test', 'unit_test', 'ocr_test_img_3.jpeg']);
    String newPath = await OCRService.checkFileSize(filePath, 2000);
    expect(newPath == filePath, true);
  });

}
