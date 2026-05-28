# Bendy 记账 - CLAUDE.md

## 项目概述
跨平台纯本地记账应用（Flutter + drift + Riverpod）

## 关键命令
- `flutter pub get` - 安装依赖
- `dart run build_runner build --delete-conflicting-outputs` - 生成 drift/riverpod 代码
- `flutter analyze` - lint 检查
- `flutter build web --release` - Web 构建
- `flutter test` - 运行测试

## 架构
- `lib/database/tables/` - drift 表定义
- `lib/database/daos/` - DAO 层
- `lib/database/app_database.dart` - drift Database 类
- `lib/repository/` - Repository 层
- `lib/provider/` - Riverpod Provider
- `lib/model/` - 枚举和数据模型
- `lib/navigation/` - 路由和自适应布局
- `lib/screen/` - 页面
- `lib/widget/` - 共享组件
- `lib/util/` - 工具类

## 注意事项
- Transaction 表使用 `@DataClassName('BendyTransaction')` 避免与 Dart 内置 Transaction 冲突
- 所有 DAO 必须导入 `app_database.dart`
- 修改表/DAO 后必须重新运行 build_runner
