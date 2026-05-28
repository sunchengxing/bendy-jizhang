import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bendy_jizhang/database/app_database.dart';
import 'package:bendy_jizhang/model/enums.dart';
import 'package:bendy_jizhang/util/amount_util.dart';
import 'package:bendy_jizhang/util/date_util.dart';
import 'package:bendy_jizhang/util/color_util.dart';
import 'package:bendy_jizhang/provider/data_provider.dart';
import 'package:fl_chart/fl_chart.dart';

enum DateRange { thisMonth, lastMonth, thisYear, all }
enum ChartType { pie, bar, line }

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  DateRange _dateRange = DateRange.thisMonth;
  TransactionType _txType = TransactionType.expense;
  ChartType _chartType = ChartType.pie;

  (String, String) get _dateRangeValues {
    final now = DateTime.now();
    switch (_dateRange) {
      case DateRange.thisMonth:
        return (DateUtil.monthStart(), DateUtil.today());
      case DateRange.lastMonth:
        final last = DateTime(now.year, now.month - 1);
        final start = '${last.year.toString().padLeft(4, '0')}-${last.month.toString().padLeft(2, '0')}-01';
        final endDay = DateTime(now.year, now.month, 0).day;
        final end = '${last.year.toString().padLeft(4, '0')}-${last.month.toString().padLeft(2, '0')}-$endDay';
        return (start, end);
      case DateRange.thisYear:
        return (DateUtil.yearStart(), DateUtil.today());
      case DateRange.all:
        return ('2000-01-01', '2100-12-31');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (start, end) = _dateRangeValues;
    final txAsync = ref.watch(transactionsByDateRangeProvider((start, end)));

    return Scaffold(
      appBar: AppBar(title: const Text('统计分析')),
      body: txAsync.when(
        data: (transactions) {
          final filtered = _txType == TransactionType.transfer
              ? transactions.where((t) => t.type != TransactionType.transfer).toList()
              : transactions.where((t) => t.type == _txType).toList();
          final total = filtered.fold<double>(0, (s, t) => s + t.sourceAmount);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Date range filters
              Wrap(
                spacing: 8,
                children: DateRange.values.map((r) => FilterChip(
                  label: Text(_rangeLabel(r)),
                  selected: _dateRange == r,
                  onSelected: (_) => setState(() => _dateRange = r),
                )).toList(),
              ),
              const SizedBox(height: 8),
              // Transaction type filter
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(label: const Text('支出'), selected: _txType == TransactionType.expense, onSelected: (_) => setState(() => _txType = TransactionType.expense)),
                  FilterChip(label: const Text('收入'), selected: _txType == TransactionType.income, onSelected: (_) => setState(() => _txType = TransactionType.income)),
                ],
              ),
              const SizedBox(height: 8),
              // Chart type toggle
              SegmentedButton<ChartType>(
                segments: const [
                  ButtonSegment(value: ChartType.pie, label: Text('饼图'), icon: Icon(Icons.pie_chart, size: 16)),
                  ButtonSegment(value: ChartType.bar, label: Text('柱状图'), icon: Icon(Icons.bar_chart, size: 16)),
                  ButtonSegment(value: ChartType.line, label: Text('趋势'), icon: Icon(Icons.show_chart, size: 16)),
                ],
                selected: {_chartType},
                onSelectionChanged: (s) => setState(() => _chartType = s.first),
              ),
              const SizedBox(height: 16),
              // Chart area
              SizedBox(
                height: 240,
                child: _buildChart(filtered, total),
              ),
              const SizedBox(height: 16),
              // Totals
              Row(
                children: [
                  Text('总${_txType == TransactionType.expense ? "支出" : "收入"}：${AmountUtil.format(total)}', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              const SizedBox(height: 16),
              // Category ranking
              Text('分类排行', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._buildRanking(filtered, total),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
      ),
    );
  }

  String _rangeLabel(DateRange r) {
    switch (r) {
      case DateRange.thisMonth: return '本月';
      case DateRange.lastMonth: return '上月';
      case DateRange.thisYear: return '今年';
      case DateRange.all: return '全部';
    }
  }

  Widget _buildChart(List<BendyTransaction> transactions, double total) {
    final byCategory = _groupByCategory(transactions);
    if (byCategory.isEmpty) return const Center(child: Text('暂无数据'));

    switch (_chartType) {
      case ChartType.pie:
        return PieChart(PieChartData(
          sections: byCategory.entries.map((e) {
            final pct = total > 0 ? e.value / total : 0.0;
            return PieChartSectionData(
              value: e.value,
              title: pct > 0.05 ? '${(pct * 100).toStringAsFixed(0)}%' : '',
              color: ColorUtil.fromHex(e.key.color),
              radius: 80,
              titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            );
          }).toList(),
        ));
      case ChartType.bar:
        final byDay = <String, double>{};
        for (final tx in transactions) {
          byDay[tx.date] = (byDay[tx.date] ?? 0) + tx.sourceAmount;
        }
        final sorted = byDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
        return BarChart(BarChartData(
          barGroups: sorted.asMap().entries.map((e) => BarChartGroupData(
            x: e.key,
            barRods: [BarChartRodData(toY: e.value.value, color: Theme.of(context).colorScheme.primary)],
          )).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ));
      case ChartType.line:
        final byDay = <String, double>{};
        double cum = 0;
        for (final tx in transactions) {
          cum += tx.sourceAmount;
          byDay[tx.date] = cum;
        }
        final sorted = byDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
        return LineChart(LineChartData(
          lineBarsData: [LineChartBarData(
            spots: sorted.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value)).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 2,
            dotData: FlDotData(show: sorted.length < 30),
          )],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ));
    }
  }

  List<Widget> _buildRanking(List<BendyTransaction> transactions, double total) {
    final byCategory = _groupByCategory(transactions);
    final sorted = byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((e) {
      final pct = total > 0 ? e.value / total : 0.0;
      return ListTile(
        leading: CircleAvatar(backgroundColor: ColorUtil.fromHex(e.key.color), radius: 16, child: const Icon(Icons.category, color: Colors.white, size: 16)),
        title: Text(e.key.name),
        trailing: SizedBox(
          width: 150,
          child: Row(
            children: [
              Expanded(child: LinearProgressIndicator(value: pct, backgroundColor: Colors.grey.shade200)),
              const SizedBox(width: 8),
              SizedBox(width: 60, child: Text(AmountUtil.format(e.value), textAlign: TextAlign.end, style: const TextStyle(fontSize: 12))),
            ],
          ),
        ),
      );
    }).toList();
  }

  Map<Category, double> _groupByCategory(List<BendyTransaction> transactions) {
    final allCats = ref.read(allCategoriesProvider).asData?.value ?? [];
    final catMap = {for (var c in allCats) c.id: c};
    final result = <Category, double>{};
    for (final tx in transactions) {
      if (tx.categoryId != null && catMap.containsKey(tx.categoryId)) {
        final cat = catMap[tx.categoryId!]!;
        result[cat] = (result[cat] ?? 0) + tx.sourceAmount;
      }
    }
    return result;
  }
}
