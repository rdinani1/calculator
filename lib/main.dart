import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(useMaterial3: true),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';

  String _currentInput = '';
  double? _firstOperand;
  String? _operator; // '+', '-', '*', '/'

  void _resetAll() {
    setState(() {
      _display = '0';
      _currentInput = '';
      _firstOperand = null;
      _operator = null;
    });
  }

  void _clearCurrent() {
    setState(() {
      _currentInput = '';
      _display = '0';
    });
  }

  void _onClearPress() {
    // If currently typing, clear only that.
    // If not typing, reset everything (AC behavior).
    if (_currentInput.isNotEmpty) {
      _clearCurrent();
    } else {
      _resetAll();
    }
  }

  void _onNumberPress(String digit) {
    setState(() {
      if (_currentInput == '0') {
        _currentInput = digit;
      } else {
        _currentInput += digit;
      }
      _display = _currentInput.isEmpty ? '0' : _currentInput;
    });
  }

  void _onOperatorPress(String op) {
    if (_currentInput.isEmpty) return;

    setState(() {
      _firstOperand = double.tryParse(_currentInput);
      _operator = op;
      _currentInput = '';
      _display = '0';
    });
  }

  void _onEqualsPress() {
    if (_firstOperand == null || _operator == null || _currentInput.isEmpty) return;

    final secondOperand = double.tryParse(_currentInput);
    if (secondOperand == null) return;

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
        return;
    }

    setState(() {
      if (result == result.roundToDouble()) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }
      _currentInput = _display;
      _firstOperand = null;
      _operator = null;
    });
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
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Text(
                _display,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
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