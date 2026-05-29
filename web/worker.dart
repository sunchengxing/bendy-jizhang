import 'package:drift/wasm.dart';

/// Drift web worker 入口点
/// 编译为 drift_worker.dart.js 供 Web 端数据库使用
void main() => WasmDatabase.workerMainForOpen();
