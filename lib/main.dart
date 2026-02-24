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
      _calcButton(label: '7', onTap: () => _onNumberPress('7')),
      _calcButton(label: '8', onTap: () => _onNumberPress('8')),
      _calcButton(label: '9', onTap: () => _onNumberPress('9')),
      const SizedBox.shrink(),

      _calcButton(label: '4', onTap: () => _onNumberPress('4')),
      _calcButton(label: '5', onTap: () => _onNumberPress('5')),
      _calcButton(label: '6', onTap: () => _onNumberPress('6')),
      const SizedBox.shrink(),

      _calcButton(label: '1', onTap: () => _onNumberPress('1')),
      _calcButton(label: '2', onTap: () => _onNumberPress('2')),
      _calcButton(label: '3', onTap: () => _onNumberPress('3')),
      const SizedBox.shrink(),

      _calcButton(label: '0', onTap: () => _onNumberPress('0')),
      const SizedBox.shrink(),
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