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
- ⏳ 账户管理（Phase 3）
- ⏳ 分类管理（Phase 3）
- ⏳ 统计分析（Phase 4）
- ⏳ 设置 + i18n（Phase 5）
