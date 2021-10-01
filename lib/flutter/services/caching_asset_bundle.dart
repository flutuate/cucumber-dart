import 'dart:async';

import 'package:cucumber_dart/flutter.dart';

import 'asset_bundle.dart';

/// An [AssetBundle] that permanently caches string and structured resources
/// that have been fetched.
///
/// Strings (for [loadString] and [loadStructuredData]) are decoded as UTF-8.
/// Data that is cached is cached for the lifetime of the asset bundle
/// (typically the lifetime of the application).
///
/// Binary resources (from [load]) are not cached.
abstract class CachingAssetBundle extends AssetBundle {
  // TODO(ianh): Replace this with an intelligent cache, see https://github.com/flutter/flutter/issues/3568
  final Map<String, Future<String>> _stringCache = <String, Future<String>>{};
  final Map<String, Future<dynamic>> _structuredDataCache = <String, Future<dynamic>>{};

  @override
  Future<String> loadString(String key, { bool cache = true }) {
    if (cache) {
      return _stringCache.putIfAbsent(key, () => super.loadString(key));
    }
    return super.loadString(key);
  }

  /// Retrieve a string from the asset bundle, parse it with the given function,
  /// and return the function's result.
  ///
  /// The result of parsing the string is cached (the string itself is not,
  /// unless you also fetch it with [loadString]). For any given `key`, the
  /// `parser` is only run the first time.
  ///
  /// Once the value has been parsed, the future returned by this function for
  /// subsequent calls will be a [SynchronousFuture], which resolves its
  /// callback synchronously.
  @override
  Future<T> loadStructuredData<T>(String key, Future<T> Function(String value) parser) {
    if (_structuredDataCache.containsKey(key)) {
      return _structuredDataCache[key]! as Future<T>;
    }
    Completer<T>? completer;
    Future<T>? result;
    loadString(key, cache: false).then<T>(parser).then<void>((T value) {
      result = SynchronousFuture<T>(value);
      _structuredDataCache[key] = result!;
      if (completer != null) {
        // We already returned from the loadStructuredData function, which means
        // we are in the asynchronous mode. Pass the value to the completer. The
        // completer's future is what we returned.
        completer.complete(value);
      }
    });
    if (result != null) {
      // The code above ran synchronously, and came up with an answer.
      // Return the SynchronousFuture that we created above.
      return result!;
    }
    // The code above hasn't yet run its "then" handler yet. Let's prepare a
    // completer for it to use when it does run.
    completer = Completer<T>();
    _structuredDataCache[key] = completer.future;
    return completer.future;
  }

  @override
  void evict(String key) {
    _stringCache.remove(key);
    _structuredDataCache.remove(key);
  }
}
