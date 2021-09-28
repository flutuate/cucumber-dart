import 'package:cucumber_dart/core.dart';
import 'package:test/test.dart';
import 'src/Calc.dart';

void main()
{
  test('Load feature file', ()
  {
    final path = 'features/Calc.feature';
    final feature = loadFeature(path);
  });
}

