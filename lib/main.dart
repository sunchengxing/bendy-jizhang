import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bendy_jizhang/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    return true;
  };
  runZonedGuarded(
    () => runApp(const BendyApp()),
    (error, stack) {},
  );
}
