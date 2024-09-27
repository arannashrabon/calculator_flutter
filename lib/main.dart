import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _expression = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                buildButtonRow(['DEL', '='], [Colors.blue, Colors.blue]),
                buildButtonRow([
                  '1',
                  '2',
                  '3',
                  '/'
                ], [
                  Colors.orange,
                  Colors.orange,
                  Colors.orange,
                  Colors.green
                ]),
                buildButtonRow([
                  '4',
                  '5',
                  '6',
                  '-'
                ], [
                  Colors.orange,
                  Colors.orange,
                  Colors.orange,
                  Colors.green
                ]),
                buildButtonRow([
                  '7',
                  '8',
                  '9',
                  'X'
                ], [
                  Colors.orange,
                  Colors.orange,
                  Colors.orange,
                  Colors.green
                ]),
                buildButtonRow(['.', '0', '%', '+'],
                    [Colors.orange, Colors.orange, Colors.green, Colors.green]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> labels, List<Color> colors) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: CalculatorButton(
              label: labels[index],
              onTap: () {
                setState(() {
                  if (labels[index] == 'DEL') {
                    _output = _output.length > 1
                        ? _output.substring(0, _output.length - 1)
                        : "0";
                    _expression = _expression.length > 1
                        ? _expression.substring(0, _expression.length - 1)
                        : "";
                  } else if (labels[index] == "=") {
                    _output = _evaluateExpression(_expression);
                    _expression = _output;
                  } else {
                    if (_output == "0") _output = "";
                    _output += labels[index];
                    _expression += (labels[index] == 'X') ? '*' : labels[index];
                  }
                });
              },
              backgroundColor: colors[index],
            ),
          );
        }),
      ),
    );
  }

  String _evaluateExpression(String input) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(input);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return eval.toString();
    } catch (e) {
      return "Error";
    }
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;

  CalculatorButton(
      {required this.label,
        required this.onTap,
        this.backgroundColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}