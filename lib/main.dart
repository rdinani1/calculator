import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  bool _isDark = false;

  ThemeData get _lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      );

  ThemeData get _darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      );

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: _isDark ? _darkTheme : _lightTheme,
      home: CalculatorScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const CalculatorScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';     // Big number/result
  String _expression = '';   // Small "123 +" line

  String _currentInput = '';
  double? _firstOperand;
  String? _operator; // '+', '-', '*', '/'

  bool _isError = false;

  String _prettyOp(String op) {
    switch (op) {
      case '/':
        return '÷';
      case '*':
        return '×';
      default:
        return op;
    }
  }

  void _setError(String message) {
    setState(() {
      _display = message;
      _expression = '';
      _currentInput = '';
      _firstOperand = null;
      _operator = null;
      _isError = true;
    });
  }

  void _resetAll() {
    setState(() {
      _display = '0';
      _expression = '';
      _currentInput = '';
      _firstOperand = null;
      _operator = null;
      _isError = false;
    });
  }

  void _clearCurrent() {
    setState(() {
      _currentInput = '';
      _display = '0';
      _isError = false;
      // Keep expression so student can continue the operation after clearing second operand
    });
  }

  void _onClearPress() {
    if (_currentInput.isNotEmpty) {
      _clearCurrent();
    } else {
      _resetAll();
    }
  }

  void _onNumberPress(String digit) {
    setState(() {
      if (_isError) {
        // Typing after an error starts fresh
        _isError = false;
        _expression = '';
        _firstOperand = null;
        _operator = null;
        _currentInput = '';
        _display = '0';
      }

      if (_currentInput == '0') {
        _currentInput = digit;
      } else {
        _currentInput += digit;
      }

      _display = _currentInput.isEmpty ? '0' : _currentInput;
    });
  }

  void _onOperatorPress(String op) {
    if (_isError) {
      _setError('Error: clear first');
      return;
    }

    if (_currentInput.isEmpty) {
      _setError('Error: no input');
      return;
    }

    final parsed = double.tryParse(_currentInput);
    if (parsed == null) {
      _setError('Error: invalid number');
      return;
    }

    setState(() {
      _firstOperand = parsed;
      _operator = op;

      // Show "123 +" in small line
      _expression = '${_formatNumber(parsed)} ${_prettyOp(op)}';

      // Clear current input so user can type second operand
      _currentInput = '';

      // IMPORTANT FIX: do NOT force the big display to 0 here.
      // Instead, keep showing the first operand until they start typing the second.
      _display = _formatNumber(parsed);
    });
  }

  void _onEqualsPress() {
    if (_isError) {
      _setError('Error: clear first');
      return;
    }

    if (_firstOperand == null || _operator == null || _currentInput.isEmpty) {
      _setError('Error: incomplete');
      return;
    }

    final secondOperand = double.tryParse(_currentInput);
    if (secondOperand == null) {
      _setError('Error: invalid number');
      return;
    }

    if (_operator == '/' && secondOperand == 0) {
      _setError('Error: /0');
      return;
    }

    double result;
    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '*':
        result = _firstOperand! * secondOperand;
        break;
      case '/':
        result = _firstOperand! / secondOperand;
        break;
      default:
        _setError('Error: bad op');
        return;
    }

    setState(() {
      // Optional: show full expression briefly in small line
      _expression =
          '${_formatNumber(_firstOperand!)} ${_prettyOp(_operator!)} ${_formatNumber(secondOperand)} =';

      _display = _formatNumber(result);

      // allow continuing from result
      _currentInput = _display;
      _firstOperand = null;
      _operator = null;
      _isError = false;
    });
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();

    // Clean up trailing zeros a bit without being too fancy
    var s = value.toString();
    if (s.contains('.')) {
      while (s.endsWith('0')) s = s.substring(0, s.length - 1);
      if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    }
    return s;
  }

  Widget _calcButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.isDark ? Icons.dark_mode : Icons.light_mode;

    final buttons = <Widget>[
      _calcButton(label: 'C/AC', onTap: _onClearPress),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
      _calcButton(label: '÷', onTap: () => _onOperatorPress('/')),

      _calcButton(label: '7', onTap: () => _onNumberPress('7')),
      _calcButton(label: '8', onTap: () => _onNumberPress('8')),
      _calcButton(label: '9', onTap: () => _onNumberPress('9')),
      _calcButton(label: '×', onTap: () => _onOperatorPress('*')),

      _calcButton(label: '4', onTap: () => _onNumberPress('4')),
      _calcButton(label: '5', onTap: () => _onNumberPress('5')),
      _calcButton(label: '6', onTap: () => _onNumberPress('6')),
      _calcButton(label: '-', onTap: () => _onOperatorPress('-')),

      _calcButton(label: '1', onTap: () => _onNumberPress('1')),
      _calcButton(label: '2', onTap: () => _onNumberPress('2')),
      _calcButton(label: '3', onTap: () => _onNumberPress('3')),
      _calcButton(label: '+', onTap: () => _onOperatorPress('+')),

      _calcButton(label: '0', onTap: () => _onNumberPress('0')),
      _calcButton(label: '=', onTap: _onEqualsPress),
      const SizedBox.shrink(),
      const SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(icon),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Display area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _display,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: _isError ? Colors.red : null,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(10),
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}