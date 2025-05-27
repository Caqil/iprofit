// lib/features/home/widgets/profit_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/utils/formatters.dart';
import 'dart:math' as math;

class ProfitData {
  final DateTime date;
  final double amount;

  const ProfitData({required this.date, required this.amount});
}

class ProfitChart extends StatefulWidget {
  final List<ProfitData> profitData;
  final Color lineColor;
  final Color gradientColor;

  const ProfitChart({
    super.key,
    required this.profitData,
    this.lineColor = Colors.blue,
    this.gradientColor = Colors.blueAccent,
  });

  @override
  State<ProfitChart> createState() => _ProfitChartState();
}

class _ProfitChartState extends State<ProfitChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _periodFilter = '7d';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Faster animation
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter data based on period selection
    final filteredData = _filterDataByPeriod(widget.profitData, _periodFilter);

    // Calculate statistics
    final totalProfit = _calculateTotalProfit(filteredData);
    final dailyAverage = _calculateDailyAverage(filteredData);
    final percentChange = _calculatePercentChange(filteredData);

    // Theme-aware colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white70 : Colors.grey[600];
    final cardColor = isDark ? Colors.grey[900] : Colors.white;

    return Card(
      elevation: 4,
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profit History',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Period selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: theme.dividerColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _periodFilter,
                      style: theme.textTheme.bodySmall,
                      dropdownColor: cardColor,
                      borderRadius: BorderRadius.circular(12),
                      items: const [
                        DropdownMenuItem(value: '7d', child: Text('7 Days')),
                        DropdownMenuItem(value: '30d', child: Text('30 Days')),
                        DropdownMenuItem(value: '90d', child: Text('90 Days')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _periodFilter = value;
                            _animationController.reset();
                            _animationController.forward();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  'Total Profit',
                  Formatters.formatCurrency(totalProfit),
                  Colors.green,
                ),
                _buildStatItem(
                  context,
                  'Daily Average',
                  Formatters.formatCurrency(dailyAverage),
                  widget.lineColor,
                ),
                _buildStatItem(
                  context,
                  'Change',
                  '${percentChange >= 0 ? '+' : ''}${percentChange.toStringAsFixed(1)}%',
                  percentChange >= 0 ? Colors.green : Colors.red,
                  icon: percentChange >= 0
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Chart
            SizedBox(
              height: 220, // Slightly taller for better visibility
              child: filteredData.isEmpty
                  ? Center(
                      child: Text(
                        'No profit data available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    )
                  : AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return LineChart(
                          _createLineChartData(filteredData, _animation.value),
                          duration: const Duration(milliseconds: 250),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProfitData> _filterDataByPeriod(List<ProfitData> data, String period) {
    if (data.isEmpty) return [];

    final now = DateTime.now();
    late DateTime cutoffDate;

    switch (period) {
      case '7d':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case '30d':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case '90d':
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      default:
        cutoffDate = now.subtract(const Duration(days: 7));
    }

    return data.where((item) => item.date.isAfter(cutoffDate)).toList()
      ..sort((a, b) => a.date.compareTo(b.date)); // Ensure chronological order
  }

  LineChartData _createLineChartData(
    List<ProfitData> data,
    double animationValue,
  ) {
    if (data.isEmpty) {
      return LineChartData();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _calculateInterval(data),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: isDark ? Colors.white12 : Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: _calculateDaysInterval(data.length),
            getTitlesWidget: (value, meta) =>
                _bottomTitleWidgets(value, meta, data),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _calculateInterval(data),
            getTitlesWidget: _leftTitleWidgets,
            reservedSize: 48,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: _getMinY(data) * 0.9,
      maxY: _getMaxY(data) * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(data.length, (index) {
            if (index <= data.length * animationValue) {
              return FlSpot(index.toDouble(), data[index].amount);
            }
            return FlSpot(
              index.toDouble(),
              data[index].amount * animationValue,
            );
          }),
          isCurved: true,
          color: widget.lineColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                widget.gradientColor.withOpacity(0.4 * animationValue),
                widget.gradientColor.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipPadding: const EdgeInsets.all(8),
          tooltipMargin: 8,
          getTooltipItems: (touchedSpots) {
            return touchedSpots
                .map((touchedSpot) {
                  final spotIndex = touchedSpot.x.toInt();
                  if (spotIndex >= 0 && spotIndex < data.length) {
                    final date = data[spotIndex].date;
                    final amount = data[spotIndex].amount;
                    return LineTooltipItem(
                      '${Formatters.formatDate(date.toString(), format: 'MMM d')}\n',
                      TextStyle(
                        color: isDark ? Colors.white : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: Formatters.formatCurrency(amount),
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  }
                  return null;
                })
                .whereType<LineTooltipItem>()
                .toList();
          },
        ),
      ),
    );
  }

  Widget _bottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<ProfitData> data,
  ) {
    final index = value.toInt();
    if (index < 0 || index >= data.length) {
      return const SizedBox.shrink();
    }

    final date = data[index].date;
    String text = '${date.day}/${date.month}';

    if (_periodFilter == '30d' || _periodFilter == '90d') {
      if (index % _calculateDaysInterval(data.length) != 0) {
        return const SizedBox.shrink();
      }
    }

    return SideTitleWidget(
      space: 8,
      meta: meta,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white70
              : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    // Use a hardcoded interval or remove interval logic
    const double interval = 100.0; // Example fallback interval
    if (value % interval == 0) {
      return SideTitleWidget(
        space: 8,
        meta: meta, // Pass the meta object to SideTitleWidget
        child: Text(
          Formatters.formatCurrency(value),
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return Container(); // Return empty widget for non-matching values
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color, {
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.white70
                : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  double _getMinY(List<ProfitData> data) {
    if (data.isEmpty) return 0;
    return data.map((e) => e.amount).reduce(math.min);
  }

  double _getMaxY(List<ProfitData> data) {
    if (data.isEmpty) return 100;
    return data.map((e) => e.amount).reduce(math.max);
  }

  double _calculateTotalProfit(List<ProfitData> data) {
    if (data.isEmpty) return 0;
    return data.fold(0, (sum, item) => sum + item.amount);
  }

  double _calculateDailyAverage(List<ProfitData> data) {
    if (data.isEmpty) return 0;
    return _calculateTotalProfit(data) / data.length;
  }

  double _calculatePercentChange(List<ProfitData> data) {
    if (data.length < 2) return 0;
    final firstValue = data.first.amount;
    final lastValue = data.last.amount;
    if (firstValue == 0) return 0;
    return ((lastValue - firstValue) / firstValue) * 100;
  }

  double _calculateInterval(List<ProfitData> data) {
    if (data.isEmpty) return 20;
    final max = _getMaxY(data);
    if (max <= 100) return 20;
    if (max <= 500) return 100;
    if (max <= 1000) return 200;
    return (max / 5).ceilToDouble();
  }

  double _calculateDaysInterval(int totalDays) {
    if (totalDays <= 7) return 1;
    if (totalDays <= 30) return 5;
    return 10;
  }
}
