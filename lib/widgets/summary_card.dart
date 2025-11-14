import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String budget;
  final double progressValue;
  final VoidCallback onMoreTap;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.budget,
    required this.progressValue,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onMoreTap,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Center(
              child: Builder(
                builder: (context) {
                  final baseStyle = Theme.of(context).textTheme.bodyLarge;
                  return RichText(
                    text: TextSpan(
                      style: baseStyle,
                      children: <TextSpan>[
                        TextSpan(
                          text: amount,
                          style: baseStyle?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '.55',
                          style: baseStyle?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: (baseStyle.fontSize ?? 24.0) * 0.75,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: Text(
                budget,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 4.0,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
