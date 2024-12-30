import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(color: Colors.white, fontSize: 32),
          headlineSmall: TextStyle(color: Colors.grey, fontSize: 24),
        ),
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
  String _input = '';
  String _display = '';
  String _operation = '';
  List<int> _numbers = [];

  void _onNumberPressed(String number) {
    setState(() {
      if (_input.length < 10) {
        _input += number;
        _display += number;
      }
    });
  }

  void _onOperationPressed(String operation) {
    if (_input.isNotEmpty) {
      _numbers.add(int.parse(_input));
      _operation = operation;
      _input = '';
      setState(() {
        _display += operation;
      });
    }
  }

  void _onEqualsPressed() {
    if (_input.isNotEmpty) {
      _numbers.add(int.parse(_input));
      int result = _numbers.first;
      for (int i = 1; i < _numbers.length; i++) {
        switch (_operation) {
          case '+':
            result += _numbers[i];
            break;
          case '-':
            result -= _numbers[i];
            break;
          case '*':
            result *= _numbers[i];
            break;
          case '/':
            if (_numbers[i] == 0) {
              setState(() {
                _display = 'Cannot divide by zero';
              });
              _numbers.clear();
              return;
            }
            result = (result / _numbers[i]).toInt();
            break;
        }
      }
      setState(() {
        _display = result.toString();
        _input = '';
        _numbers.clear();
        _operation = '';
      });
    }
  }

  void _onClearPressed() {
    setState(() {
      _input = '';
      _display = '';
      _operation = '';
      _numbers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Simple Calculator',
            style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _display.isEmpty ? '' : _display,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  final buttons = [
                    '7',
                    '8',
                    '9',
                    '/',
                    '4',
                    '5',
                    '6',
                    '*',
                    '1',
                    '2',
                    '3',
                    '-',
                    'C',
                    '0',
                    '=',
                    '+'
                  ];
                  final button = buttons[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: button == 'C'
                          ? Colors.orange
                          : (button == '=' || '+-*/'.contains(button))
                              ? Colors.grey[850]
                              : Colors.grey[700],
                      foregroundColor: button == '=' || button == 'C'
                          ? Colors.white
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      if (button == 'C') {
                        _onClearPressed();
                      } else if (button == '=') {
                        _onEqualsPressed();
                      } else if ('+-*/'.contains(button)) {
                        _onOperationPressed(button);
                      } else {
                        _onNumberPressed(button);
                      }
                    },
                    child: Text(
                      button,
                      style: const TextStyle(fontSize: 24),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
