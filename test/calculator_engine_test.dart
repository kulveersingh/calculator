import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/calculator_engine.dart';

void main() {
  group('CalculatorEngine', () {
    test('addition', () {
      final e = CalculatorEngine();
      e.inputDigit('2');
      e.inputDigit('+'); // ignored, '+' not a digit
      e.applyOp(CalcOp.add);
      e.inputDigit('3');
      e.inputDigit('0');
      e.equals();
      expect(e.display, '32');
    });

    test('subtraction chains operands', () {
      final e = CalculatorEngine();
      e.inputDigit('9');
      e.applyOp(CalcOp.subtract);
      e.inputDigit('4');
      e.equals();
      expect(e.display, '5');
    });

    test('multiplication', () {
      final e = CalculatorEngine();
      e.inputDigit('6');
      e.applyOp(CalcOp.multiply);
      e.inputDigit('7');
      e.equals();
      expect(e.display, '42');
    });

    test('division by zero yields Error', () {
      final e = CalculatorEngine();
      e.inputDigit('5');
      e.applyOp(CalcOp.divide);
      e.inputDigit('0');
      e.equals();
      expect(e.display, 'Error');
    });

    test('decimal formatting removes noise', () {
      final e = CalculatorEngine();
      e.inputDigit('0');
      e.inputDecimal();
      e.inputDigit('1');
      e.applyOp(CalcOp.divide);
      e.inputDigit('3');
      e.equals();
      // 0.1 / 3 = 0.0333... rounded cleanly
      expect(e.display, '0.033333333333');
    });

    test('toggle sign', () {
      final e = CalculatorEngine();
      e.inputDigit('5');
      e.toggleSign();
      expect(e.display, '-5');
      e.toggleSign();
      expect(e.display, '5');
    });

    test('clear resets everything', () {
      final e = CalculatorEngine();
      e.inputDigit('7');
      e.applyOp(CalcOp.add);
      e.inputDigit('3');
      e.clearAll();
      expect(e.display, '0');
      expect(e.pendingOpLabel, isNull);
    });

    test('chained multiply then add', () {
      final e = CalculatorEngine();
      e.inputDigit('2');
      e.applyOp(CalcOp.multiply);
      e.inputDigit('3');
      e.applyOp(CalcOp.add); // 2*3 = 6 evaluated before queuing '+'
      expect(e.display, '6');
      e.inputDigit('4');
      e.equals();
      expect(e.display, '10');
    });
  });
}
