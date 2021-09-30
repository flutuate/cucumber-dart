import 'package:gherkin/Gherkin.dart';
import 'package:gherkin/language.dart';
import 'package:gherkin/messages.dart';
import 'package:test/test.dart';

void feature(String path, void Function() body) async {
  final envelope = await loadFeature(path);
  print(envelope);
  test('bla', body);
}

Future<Envelope> loadFeature(String path) async {
  final idGenerator = IdGenerator.incrementingGenerator;
  final paths = <String>[path];
  final includeSource = false;
  final includeAst = true;
  final includePickles = true;
  final stream = await Gherkin.fromPaths(paths, includeSource, includeAst
      , includePickles, idGenerator);
  return stream.first;
}

