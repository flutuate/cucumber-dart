import 'package:cucumber_dart/core.dart';
import 'package:test/test.dart';

void main()
{
  test('Load feature file', ()
  async {
    final path = 'test/features/Calc.feature';
    final feature = loadFeature(path);
    print(feature);
  });
}

