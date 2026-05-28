class AmountUtil {
  static String format(double amount, {String currency = '¥'}) {
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2);
    final prefix = amount < 0 ? '-' : '';
    return '$currency$prefix$formatted';
  }

  static String formatWithSign(double amount, {String currency = '¥'}) {
    final absAmount = amount.abs();
    final formatted = absAmount.toStringAsFixed(2);
    if (amount > 0) return '+$currency$formatted';
    if (amount < 0) return '-$currency$formatted';
    return '$currency$formatted';
  }
}
