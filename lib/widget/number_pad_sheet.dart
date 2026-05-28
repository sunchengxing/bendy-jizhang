import 'package:flutter/material.dart';

Future<double?> showNumberPad(BuildContext context, {double? initialValue}) {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _NumberPadSheet(initialValue: initialValue),
  );
}

class _NumberPadSheet extends StatefulWidget {
  final double? initialValue;
  const _NumberPadSheet({this.initialValue});

  @override
  State<_NumberPadSheet> createState() => _NumberPadSheetState();
}

class _NumberPadSheetState extends State<_NumberPadSheet> {
  late String _display;

  @override
  void initState() {
    super.initState();
    _display = widget.initialValue != null
        ? widget.initialValue!.toStringAsFixed(2)
        : '0';
    if (_display == '0.00') _display = '0';
  }

  void _onKey(String key) {
    setState(() {
      if (key == 'C') {
        _display = '0';
      } else if (key == '⌫') {
        _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0';
      } else if (key == '.') {
        if (!_display.contains('.')) _display += '.';
      } else if (key == 'OK') {
        Navigator.pop(context, double.tryParse(_display) ?? 0.0);
        return;
      } else {
        if (_display == '0') {
          _display = key;
        } else if (_display.contains('.')) {
          final parts = _display.split('.');
          if (parts.length == 2 && parts[1].length < 2) _display += key;
        } else {
          _display += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['7', '8', '9', '⌫'],
      ['4', '5', '6', 'C'],
      ['1', '2', '3', 'OK'],
      ['.', '0', '00', 'OK'],
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('输入金额', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: Text('¥ $_display',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: keys.map((row) => Expanded(
                  child: Row(
                    children: row.map((key) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: FilledButton(
                          onPressed: () => _onKey(key),
                          style: key == 'OK'
                              ? FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary)
                              : null,
                          child: Text(key, style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    )).toList(),
                  ),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
