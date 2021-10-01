import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import 'asset_bundle.dart';
import 'caching_asset_bundle.dart';

/// An [AssetBundle] that loads resources using platform messages.
class PlatformAssetBundle extends CachingAssetBundle
{
  static const notFound = -1;
  static const _pubspec = 'pubspec.yaml';
  static String _packagePath = '';

  static Future<AssetBundle> build({String metadata=''}) async {
    _packagePath = Directory.current.path;
    final pubspecPath = _packagePath + path.separator + _pubspec;
    var text = await File(pubspecPath).readAsString();
    var yaml = loadYaml(text);
    if( metadata.isNotEmpty ) {
      yaml = _parseMetadata(yaml, metadata);
    }
    if( yaml is YamlList ) {
      yaml = _parseAndSortList(yaml);
    }
    else {
      yaml = <String>[];
    }
    return PlatformAssetBundle._(metadata.isEmpty ? _pubspec : metadata, yaml);
  }

  static dynamic _parseMetadata(dynamic yaml, String metadata) {
    final keys = metadata.split('/');
    for( var key in keys ) {
      yaml = yaml[key];
    }
    return yaml;
  }

  static List<String> _parseAndSortList(YamlList yaml) {
    return yaml.map((element) => element.toString()).toList()..sort();
  }

  final String metadata;

  final List<String> _assets;

  PlatformAssetBundle._(this.metadata, this._assets);

  @override
  Future<ByteData> load(String key) async {
    if( binarySearch(_assets, key) == notFound ) {
      throw Exception('Unable to load asset: $key');
    }
    final filepath = _packagePath + path.separator + key;
    Uint8List bytes = await File(filepath).readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}
