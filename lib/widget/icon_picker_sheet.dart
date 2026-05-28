import 'package:flutter/material.dart';

const IconNames = <String, IconData>{
  'account_balance': Icons.account_balance,
  'money': Icons.money,
  'credit_card': Icons.credit_card,
  'savings': Icons.savings,
  'wallet': Icons.wallet,
  'phone_android': Icons.phone_android,
  'home': Icons.home,
  'directions_car': Icons.directions_car,
  'restaurant': Icons.restaurant,
  'shopping_cart': Icons.shopping_cart,
  'sports_esports': Icons.sports_esports,
  'local_hospital': Icons.local_hospital,
  'school': Icons.school,
  'payments': Icons.payments,
  'card_giftcard': Icons.card_giftcard,
  'trending_up': Icons.trending_up,
  'work': Icons.work,
  'star': Icons.star,
  'inventory_2': Icons.inventory_2,
  'flight': Icons.flight,
  'coffee': Icons.coffee,
  'category': Icons.category,
};

Future<String?> showIconPickerSheet(BuildContext context, {String? selected}) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (_) => _IconPickerGrid(selected: selected),
  );
}

class _IconPickerGrid extends StatelessWidget {
  final String? selected;
  const _IconPickerGrid({this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8, runSpacing: 8,
        children: IconNames.keys.map((name) {
          final isSelected = name == selected;
          return GestureDetector(
            onTap: () => Navigator.pop(context, name),
            child: CircleAvatar(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Icon(IconNames[name]!, color: isSelected ? Colors.white : null, size: 20),
            ),
          );
        }).toList(),
      ),
    );
  }
}
