import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsState build() => SettingsState(
    themeMode: ThemeMode.system,
    currency: 'CNY',
  );

  void setThemeMode(ThemeMode mode) => state = state.copyWith(themeMode: mode);
  void setCurrency(String cur) => state = state.copyWith(currency: cur);
}

class SettingsState {
  final ThemeMode themeMode;
  final String currency;
  final String themeColor;
  final bool showAmount;

  const SettingsState({
    required this.themeMode,
    required this.currency,
    this.themeColor = '#6200EE',
    this.showAmount = true,
  });

  SettingsState copyWith({ThemeMode? themeMode, String? currency, String? themeColor, bool? showAmount}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      themeColor: themeColor ?? this.themeColor,
      showAmount: showAmount ?? this.showAmount,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);
