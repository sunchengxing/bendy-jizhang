import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bendy_jizhang/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Release 模式下让 ErrorWidget 显示错误文本而非灰屏
  ErrorWidget.builder = (details) => Material(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              details.exceptionAsString(),
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      );

  FlutterError.onError = (details) => FlutterError.presentError(details);
  PlatformDispatcher.instance.onError = (error, stack) => true;

  runZonedGuarded(() => runApp(const BendyApp()), (error, stack) {});
}
