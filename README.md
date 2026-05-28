# Bendy 记账 (bendy-jizhang)

跨平台纯本地记账应用，Flutter 一套代码 → Android + Desktop + Web。

## 业务前缀

- 数据表：`accounts`, `transactions`, `categories`
- 无 Redis（纯本地 SQLite）

## 技术栈

- Flutter 3.44 / Dart 3.12
- drift (SQLite ORM) + sqlite3_flutter_libs
- Riverpod (状态管理)
- go_router (导航)
- fl_chart (图表)

## 运行

```bash
flutter pub get
flutter run
```

## 构建

```bash
flutter build web --release
flutter build apk --release
flutter build windows --release
```

## 远程仓库

https://github.com/sunchengxing/bendy-jizhang
