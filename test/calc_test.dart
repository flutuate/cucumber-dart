import 'package:cucumber_dart/core.dart';
import 'package:test/test.dart';

import 'src/Calc.dart';

void main()
{
  feature('features/calc.feature', () {
    var calc = Calc();

    given('I have a Calculator', () {
      calc.clear();
    });

    when('I add {int} and {int}', (params) {
      calc.sum(params[0], params[1]);
    });

    then('the sum should be {int}', (params) {
      expect( calc.lastResult, equals(params[0]));
    });
  });
/*
  // ------- or ------------

  test('Adding numbers with a Calculator', () {
    feature('Adding numbers with a Calculator', () {
      scenario('Add two positive numbers', () {
        var calc = Calc();
        given('I have a Calculator', () {
          calc.clear();
        });
        when('I add {int} and {int}', (params) {
          calc.sum(params[0], params[1]);
        });
        then('the sum should be {int}', (params) {
          expect( calc.lastResult, equals(params[0]));
        });
      });
    });
  });

  // ------- or ------------

  var calc = Calc();

  given('I have a Calculator', () {
    calc.clear();
  });

  when('I add {int} and {int}', (params) {
    calc.sum(params[0], params[1]);
  });

  then('the sum should be {int}', (params) {
    expect( calc.lastResult, equals(params[0]));
  });*/
}
