import 'dart:convert';

import 'package:cucumber_dart/flutter.dart';
import 'package:test/test.dart';

import 'src/user.dart';

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

  test('Load string from not declared asset causes error', () async {
    final assets =
        await PlatformAssetBundle.build(metadata: 'cucumber/features');
    expect(
        () async =>
            await assets.loadString('test/features/not-exists.feature'),
        throwsException);
  });

  test('Load structured data from json asset file', () async {
    final assets =
    await PlatformAssetBundle.build(metadata: 'test/assets');
    final user = await assets.loadStructuredData<User>('test/json/user.json',
        (value) => Future.value(User.fromJson(jsonDecode(value)))
    );
    expect(user.name, equals('John Doe'));
    expect(user.age, equals(45));
  });

}
