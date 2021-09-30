import 'package:cucumber_dart/flutter.dart';
import 'package:test/test.dart';

void main() {
  test('Load pubspec.yaml from package root dir', () async {
    final assets = await PlatformAssetBundle.build();
    expect(assets, isNotNull);
  });

  test('Load string from asset file', () async {
    final assets =
        await PlatformAssetBundle.build(metadata: 'cucumber/features');
    final text = await assets.loadString('test/features/calc.feature');
    expect(text, isNotEmpty);
  });

  test('Load string from asset not declared cause error', () async {
    final assets =
        await PlatformAssetBundle.build(metadata: 'cucumber/features');
    expect(
        () async => await assets.loadString('test/features/not-exists.feature'),
        throwsException);
  });
}
