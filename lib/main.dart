import 'package:flutter/material.dart';

import 'calculator_engine.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final CalculatorEngine _engine = CalculatorEngine();

  void _onOp(CalcOp op) {
    setState(() => _engine.applyOp(op));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Text(
                        _engine.pendingOpLabel ?? '',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 28,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Main display result.
                    Text(
                      _engine.display,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                        height: 1,
                      ),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildKeypad(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    // Row-major grid. Each tile is a [CalcTile].
    final row1 = <CalcTile>[
      CalcTile('C', _engine.clearAll, isWide: false, isFunction: true),
      CalcTile('±', _engine.toggleSign, isWide: false, isFunction: true),
      CalcTile('%', _engine.percent, isWide: false, isFunction: true),
      CalcTile('÷', () => _onOp(CalcOp.divide), isFunction: true),
    ];
    final row2 = <CalcTile>[
      CalcTile('7', () => _engine.inputDigit('7')),
      CalcTile('8', () => _engine.inputDigit('8')),
      CalcTile('9', () => _engine.inputDigit('9')),
      CalcTile('×', () => _onOp(CalcOp.multiply), isFunction: true),
    ];
    final row3 = <CalcTile>[
      CalcTile('4', () => _engine.inputDigit('4')),
      CalcTile('5', () => _engine.inputDigit('5')),
      CalcTile('6', () => _engine.inputDigit('6')),
      CalcTile('−', () => _onOp(CalcOp.subtract), isFunction: true),
    ];
    final row4 = <CalcTile>[
      CalcTile('1', () => _engine.inputDigit('1')),
      CalcTile('2', () => _engine.inputDigit('2')),
      CalcTile('3', () => _engine.inputDigit('3')),
      CalcTile('+', () => _onOp(CalcOp.add), isFunction: true),
    ];
    final row5 = <CalcTile>[
      CalcTile('0', () => _engine.inputDigit('0'), isWide: true),
      CalcTile('.', _engine.inputDecimal),
      CalcTile('=', _engine.equals, isFunction: true),
    ];

    final rows = <Widget>[
      GridRow(row1),
      GridRow(row2),
      GridRow(row3),
      GridRow(row4),
      GridRow(row5),
    ];

    return Column(
      children: [
        for (int i = 0; i < rows.length; i++) ...[
          Expanded(child: Padding(padding: const EdgeInsets.only(bottom: 8), child: rows[i])),
        ],
      ],
    );
  }
}

/// A single keypad tile. Wide tiles span two columns (used for '0').
class CalcTile {
  final String label;
  final VoidCallback onTap;
  final bool isWide;
  final bool isFunction;

  const CalcTile(
    this.label,
    this.onTap, {
    this.isWide = false,
    this.isFunction = false,
  });

  @override
  String toString() => '$runtimeType($label)';
}

/// A horizontal row of tiles laid out with Row + flexible widths.
class GridRow extends StatelessWidget {
  const GridRow(this.tiles, {super.key});

  final List<CalcTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tile in tiles)
          Expanded(
            flex: tile.isWide ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _Tile(
                label: tile.label,
                onTap: tile.onTap,
                isFunction: tile.isFunction,
              ),
            ),
          ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.onTap, required this.isFunction});

  final String label;
  final VoidCallback onTap;
  final bool isFunction;

  @override
  Widget build(BuildContext context) {
    final isEquals = label == '=' && isFunction;
    return AspectRatio(
      aspectRatio: 0.9,
      child: Material(
        color: isFunction
            ? (isEquals ? Colors.indigo.shade700 : Colors.white10)
            : Colors.white10,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isFunction ? Colors.white : Colors.white70,
                fontSize: 32,
                fontWeight: isFunction ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
