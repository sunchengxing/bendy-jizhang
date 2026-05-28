## v0.5.0 - 2026-05-28

### 变更内容
- SettingsScreen + SettingsProvider（主题/货币/清除数据）
- 主题模式切换（系统/浅色/深色）实时生效
- 货币选择（CNY/USD/EUR/JPY/GBP/KRW）
- 清除所有数据功能
- app.dart 连接 settings 实时切换主题
- 版本号更新至 0.5.0

## v0.4.0 - 2026-05-28

### 变更内容
- StatisticsScreen（日期范围 + 类型 + 图表切换）
- 饼图/柱状图/趋势线 (fl_chart)
- 分类排行 + 进度条

## v0.3.0 - 2026-05-28

### 变更内容
- AccountListScreen（资产/负债分组 + 净值卡片）
- AccountEditScreen（新建/编辑 + 图标/颜色选择）
- CategoryListScreen（支出/收入切换 + 二级分类）
- ColorPickerSheet + IconPickerSheet

## v0.2.0 - 2026-05-28

### 变更内容
- TransactionEditScreen（支出/收入/转账 + 表单）
- TransactionListScreen（按月分组 + 搜索 + 滑动删除）
- BottomSheet 组件（分类/账户/日期/数字键盘）

## v0.1.0 - 2026-05-28

### 变更内容
- 初始化 Flutter 项目（Android + Desktop + Web 三端）
- drift 数据层：accounts / transactions / categories 三表 + 3 DAO + 3 Repository
- Riverpod Provider：database / repository / data stream
- go_router 路由 + ShellRoute 自适应布局（BottomNav / NavigationRail）
- Material3 主题（light/dark）
- 预设数据初始化（9 支出分类 + 5 收入分类 + 3 账户）
- 工具类：AmountUtil / DateUtil / ColorUtil
- HomeScreen 首页仪表盘（多周期汇总 + 最近交易）
- 占位 Screen：TransactionEdit / TransactionList / AccountList / CategoryList / Statistics / Settings

### 影响范围
- 全新项目，无旧代码影响

### 功能列表
- ✅ 首页仪表盘（今日/本周/本月/本年 收支汇总）
- ✅ 数据层完整（drift 表/DAO/Repository/Provider）
- ✅ 自适应导航（移动端 BottomNav / 桌面端 NavigationRail）
- ✅ 记账页（支出/收入/转账 + 表单 + 数字键盘）
- ✅ 交易列表（按月分组 + 搜索 + 滑动删除）
- ✅ 账户管理（资产/负债分组 + 净值 + 新建/编辑）
- ✅ 分类管理（支出/收入 + 二级分类 + 颜色选择）
- ✅ 统计分析（饼图/柱状图/趋势线 + 分类排行）
- ✅ 设置（主题切换 + 货币 + 清除数据）
- ⏳ 分类管理（Phase 3）
- ⏳ 统计分析（Phase 4）
- ⏳ 设置 + i18n（Phase 5）
