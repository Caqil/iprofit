// lib/features/home/widgets/income_chart_card.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/theme.dart';
import '../providers/home_provider.dart';
import 'dart:math' as math;

class IncomeChartCard extends StatefulWidget {
  final List<ProfitData> profitData;

  const IncomeChartCard({super.key, required this.profitData});

  @override
  State<IncomeChartCard> createState() => _IncomeChartCardState();
}

class _IncomeChartCardState extends State<IncomeChartCard> {
  String selectedPeriod = '7d';

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.canvasColor, theme.primaryColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.disabledColor.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: AppTheme.primaryColor,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Income Graph',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Show detailed graph or analytics
                },
                child: Text(
                  '7d',
                  style: TextStyle(color: theme.primaryColor, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Chart
          SizedBox(
            height: 150,
            child: filteredData.isEmpty
                ? const Center(
                    child: Text('No data available', style: TextStyle()),
                  )
                : LineChart(_createChartData()),
          ),
          const SizedBox(height: 16),

          // Week days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Text(day, style: const TextStyle(fontSize: 10)))
                .toList(),
          ),
        ],
      ),
    );
  }

  List<ProfitData> _getFilteredData() {
    if (widget.profitData.isEmpty) return [];

    // Get last 7 days of data
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return widget.profitData
        .where((data) => data.date.isAfter(sevenDaysAgo))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  LineChartData _createChartData() {
    final data = _getFilteredData();
    if (data.isEmpty) return LineChartData();

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 6, // 7 days (0-6)
      minY: _getMinY(data) * 0.9,
      maxY: _getMaxY(data) * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: _generateSpots(data),
          isCurved: true,
          color: AppTheme.primaryColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.primaryColor,
                strokeWidth: 0,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.3),
                AppTheme.primaryColor.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots(List<ProfitData> data) {
    if (data.isEmpty) return [];

    // Create spots for 7 days (0-6)
    final spots = <FlSpot>[];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: 6 - i));
      final dayData = data
          .where(
            (d) =>
                d.date.year == date.year &&
                d.date.month == date.month &&
                d.date.day == date.day,
          )
          .toList();

      final dayTotal = dayData.fold(0.0, (sum, d) => sum + d.amount);
      spots.add(FlSpot(i.toDouble(), dayTotal));
    }

    return spots;
  }

  double _getMinY(List<ProfitData> data) {
    if (data.isEmpty) return 0;
    return data.map((e) => e.amount).reduce(math.min);
  }

  double _getMaxY(List<ProfitData> data) {
    if (data.isEmpty) return 100;
    return data.map((e) => e.amount).reduce(math.max);
  }
}
