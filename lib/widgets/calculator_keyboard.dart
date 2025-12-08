import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;
  final VoidCallback onDone;

  const CalculatorKeyboard({
    super.key,
    required this.controller,
    required this.accentColor,
    required this.onDone,
  });

  double _evaluateExpression(String expression) {
    if (expression.isEmpty) return 0.0;

    // Handle "x" as "*"
    String cleanExp = expression.replaceAll('x', '*');

    if (double.tryParse(cleanExp) != null) {
      return double.parse(cleanExp);
    }

    try {
      // Strip trailing operators
      if (cleanExp.endsWith('+') ||
          cleanExp.endsWith('-') ||
          cleanExp.endsWith('*') ||
          cleanExp.endsWith('/') ||
          cleanExp.endsWith('.')) {
        cleanExp = cleanExp.substring(0, cleanExp.length - 1);
      }

      final result = cleanExp.interpret();
      return result.toDouble();
    } catch (e) {
      debugPrint('Calc error: $e');
      return 0.0;
    }
  }

  void _handleKeyPress(BuildContext context, String key) {
    final text = controller.text;
    final selection = controller.selection;

    int start = selection.start;
    int end = selection.end;

    // If no selection, assume cursor is at the end
    if (start == -1) {
      start = text.length;
      end = text.length;
    }

    String newText = text;
    int newCursorPos = start;

    if (key == 'AC') {
      newText = '';
      newCursorPos = 0;
    } else if (key == 'DEL') {
      if (start == end && start > 0) {
        newText = text.substring(0, start - 1) + text.substring(end);
        newCursorPos = start - 1;
      } else if (start != end) {
        newText = text.substring(0, start) + text.substring(end);
        newCursorPos = start;
      }
    } else if (key == '=') {
      final val = _evaluateExpression(text);
      if (val % 1 == 0) {
        newText = val.toInt().toString();
      } else {
        newText = val.toStringAsFixed(2);
      }
      newCursorPos = newText.length;
    } else if (key == 'DONE') {
      // Evaluate before finishing
      final val = _evaluateExpression(text);
      if (val % 1 == 0) {
        newText = val.toInt().toString();
      } else {
        newText = val.toStringAsFixed(2);
      }
      // Update one last time
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
      onDone();
      return; // Return early as we called onDone
    } else {
      // Insert key
      newText = text.substring(0, start) + key + text.substring(end);
      newCursorPos = start + key.length;
    }

    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      'AC',
      '/',
      'x',
      'DEL',
      '7',
      '8',
      '9',
      '-',
      '4',
      '5',
      '6',
      '+',
      '1',
      '2',
      '3',
      '=',
      '00',
      '0',
      '.',
      'DONE',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              final isOperator = ['/', 'x', '-', '+', '='].contains(key);
              final isAction = ['DEL', 'AC', 'DONE'].contains(key);
              final isDone = key == 'DONE';

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _handleKeyPress(context, key),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOperator
                          ? accentColor.withValues(alpha: 0.30)
                          : isAction
                          ? Theme.of(
                              context,
                            ).colorScheme.errorContainer.withValues(alpha: 0.5)
                          : Theme.of(context).colorScheme.secondaryContainer
                                .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: isDone
                        ? Icon(Icons.check_rounded, size: 28)
                        : key == 'DEL'
                        ? Icon(Icons.backspace_rounded, size: 20)
                        : Text(
                            key,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isOperator
                                  ? accentColor
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
