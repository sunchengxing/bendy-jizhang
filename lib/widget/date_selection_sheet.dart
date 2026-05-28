import 'package:flutter/material.dart';

class DateSelectionSheet extends StatelessWidget {
  final String? initialDate;
  const DateSelectionSheet({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    DateTime selected = initialDate != null
        ? DateTime.parse(initialDate!)
        : DateTime.now();

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('选择日期', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: CalendarDatePicker(
              initialDate: selected,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (date) {
                final dateStr = '${date.year.toString().padLeft(4, '0')}-'
                    '${date.month.toString().padLeft(2, '0')}-'
                    '${date.day.toString().padLeft(2, '0')}';
                Navigator.pop(context, dateStr);
              },
            ),
          ),
        ],
      ),
    );
  }

  static Future<String?> show(BuildContext context, {String? initialDate}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => DateSelectionSheet(initialDate: initialDate),
    );
  }
}
