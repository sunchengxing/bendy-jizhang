# Bendy 记账 - 开发计划

## Phase 1：项目骨架 + 数据层（v0.1.0）
- [x] 安装 Flutter SDK ✅ 2026-05-28
- [x] 初始化 Git 仓库 + GitHub 推送 ✅ 2026-05-28
- [x] flutter create 项目骨架 + pubspec.yaml ✅ 2026-05-28
- [x] drift 表定义 (accounts/transactions/categories) ✅ 2026-05-28
- [x] AppDatabase + 3 DAO + build_runner 生成 ✅ 2026-05-28
- [x] 3 个 Repository ✅ 2026-05-28
- [x] Riverpod Provider (database/repository/stream) ✅ 2026-05-28
- [x] main.dart + app.dart + MaterialApp.router ✅ 2026-05-28
- [x] Material3 主题 ✅ 2026-05-28
- [x] go_router + ShellRoute 自适应布局 ✅ 2026-05-28
- [x] 预设数据初始化 ✅ 2026-05-28
- [x] 首页仪表盘 HomeScreen ✅ 2026-05-28
- [x] lint / build 通过 ✅ 2026-05-28

## Phase 2：导航 + 首页 + 记账核心（v0.2.0）
- [ ] TransactionEditScreen（三种类型 + 表单）
- [ ] TransactionListScreen（按月分组 + 搜索）
- [ ] BottomSheet 组件（分类/账户/日期选择）
- [ ] NumberPadSheet（数字键盘）
- [ ] 桌面快捷键 Ctrl+N

## Phase 3：账户 + 分类管理（v0.3.0）
- [ ] AccountListScreen（资产/负债分组 + 净值）
- [ ] AccountEditScreen（新建/编辑）
- [ ] CategoryListScreen（支出/收入切换）
- [ ] CategoryEditScreen（二级分类）
- [ ] ColorPickerSheet + IconPickerSheet

## Phase 4：统计分析（v0.4.0）
- [ ] StatisticsScreen（日期范围 + 数据类型切换）
- [ ] 饼图 / 柱状图 / 趋势线 (fl_chart)
- [ ] 分类排行列表

## Phase 5：设置 + i18n + 发布（v0.5.0）
- [ ] SettingsScreen + SettingsProvider
- [ ] 暗色模式切换 + 主题色
- [ ] 中英文本地化 (ARB)
- [ ] Android 签名 + Web 部署
- [ ] 全面单元/Widget 测试
