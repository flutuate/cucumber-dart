import 'package:gherkin/Gherkin.dart';
import 'package:gherkin/language.dart';
import 'package:gherkin/messages.dart';
import 'package:test/test.dart';

void feature(String path, void Function() body) async {
  final envelope = await loadFeature(path);
  print(envelope);
  test('bla', body);
}

Future<Envelope> loadFeature(String path) {
  final idGenerator = IdGenerator.incrementingGenerator;
  final paths = const <String>['test/assets/testdata/good/minimal.feature'];
  final includeSource = false;
  final includeAst = true;
  final includePickles = true;
  return Gherkin.fromPaths(paths, includeSource, includeAst
      , includePickles, idGenerator).first;
}
