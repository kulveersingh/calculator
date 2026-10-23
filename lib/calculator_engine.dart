/// The possible operations the calculator can perform.
enum CalcOp { add, subtract, multiply, divide }

/// Immutable, testable calculator logic, separate from the UI.
class CalculatorEngine {
  String display = '0';

  double? _pendingOperand;
  CalcOp? _pendingOp;

  /// Whether the next digit starts a fresh input (after '=' or after op).
  bool _startFresh = true;

  /// The operation currently being carried, shown above the display.
  String? get pendingOpLabel {
    final op = _pendingOp;
    if (op == null || _pendingOperand == null) return null;
    final symbol = switch (op) {
      CalcOp.add => '+',
      CalcOp.subtract => '−',
      CalcOp.multiply => '×',
      CalcOp.divide => '÷',
    };
    return '$_pendingOperand $symbol';
  }

  /// Current display value as a double, for chaining.
  double get _current => double.parse(display);

  void inputDigit(String digit) {
    if (_startFresh) {
      display = digit;
      _startFresh = false;
    } else {
      display = display == '0' ? digit : '$display$digit';
    }
  }

  void inputDecimal() {
    if (_startFresh) {
      display = '0.';
      _startFresh = false;
      return;
    }
    if (!display.contains('.')) display = '$display.';
  }

  void clearAll() {
    display = '0';
    _pendingOperand = null;
    _pendingOp = null;
    _startFresh = true;
  }

  /// Toggle sign of the current display value.
  void toggleSign() {
    if (display == '0') return;
    display = display.startsWith('-')
        ? display.substring(1)
        : '-$display';
  }

  /// Percentage: interpret the display as a fraction of 100.
  void percent() {
    display = _format(_current / 100);
    _startFresh = true;
  }

  /// Queue an operation to be applied to the next entered value.
  void applyOp(CalcOp op) {
    final current = _current;
    if (_pendingOp != null && !_startFresh) {
      // Evaluate the chained operation before queuing a new one.
      final result = _compute(_pendingOperand!, current, _pendingOp!);
      display = _format(result);
      _pendingOperand = result;
    } else {
      _pendingOperand = current;
    }
    _pendingOp = op;
    _startFresh = true;
  }

  /// Evaluate the queued operation against the newly entered value.
  void equals() {
    final op = _pendingOp;
    final operand = _pendingOperand;
    if (op == null || operand == null) return;
    final result = _compute(operand, _current, op);
    display = _format(result);
    _pendingOperand = null;
    _pendingOp = null;
    _startFresh = true;
  }

  double _compute(double a, double b, CalcOp op) {
    return switch (op) {
      CalcOp.add => a + b,
      CalcOp.subtract => a - b,
      CalcOp.multiply => a * b,
      CalcOp.divide => b == 0 ? double.nan : a / b,
    };
  }

  /// Format a result: drop trailing zeros, handle division by zero.
  String _format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    // Round to clean up floating-point noise such as 0.30000000000000004.
    final rounded = (value * 1e12).round() / 1e12;
    var text = rounded.toString();
    // Drop a trailing ".0" so whole numbers render without a decimal point.
    if (rounded == rounded.floor() && rounded.abs() < 1e15) {
      text = rounded.toInt().toString();
    }
    // Fall back to scientific notation for very large or tiny magnitudes.
    final abs = value.abs();
    if (abs >= 1e15 || (abs != 0 && abs < 1e-7)) {
      return value.toStringAsExponential(6);
    }
    return text;
  }
}
