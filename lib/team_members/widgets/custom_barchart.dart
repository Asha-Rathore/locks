import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/app_colors.dart';

class CustomBarChartWidget extends StatelessWidget {
  CustomBarChartWidget({super.key});
  List<_ChartData> data = [
    _ChartData(0, 0, 3.5, 4),
    _ChartData(1, 0, 9.3, 9),
    _ChartData(2, 0, 7, 7.9),
    _ChartData(3, 0, 10, 11),
    _ChartData(4, 0, 4, 3.7),
    _ChartData(5, 0, 8, 8.1),
    _ChartData(6, 0, 9, 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: SfCartesianChart(
        plotAreaBorderColor: AppColors.THEME_COLOR_TRANSPARENT,
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          borderColor: AppColors.THEME_COLOR_GRAPH_BORDER,
          majorTickLines: MajorTickLines(width: 0),
          labelStyle: TextStyle(color: AppColors.THEME_COLOR_TRANSPARENT),
          axisLine: AxisLine(color: AppColors.THEME_COLOR_GRAPH_BORDER),
        ),
        primaryYAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: TextStyle(color: AppColors.THEME_COLOR_TRANSPARENT),
          majorTickLines: MajorTickLines(
              size: 15, color: AppColors.THEME_COLOR_GRAPH_BORDER),
          axisLine: AxisLine(color: AppColors.THEME_COLOR_GRAPH_BORDER),
        ),
        series: <RangeColumnSeries<_ChartData, num>>[
          RangeColumnSeries<_ChartData, num>(
            dataSource: data,
            legendIconType: LegendIconType.circle,
            xValueMapper: (_ChartData sales, _) => sales.x,
            lowValueMapper: (_ChartData sales, _) => sales.y,
            highValueMapper: (_ChartData sales, _) => sales.z,
            color: AppColors.THEME_COLOR_DARK_GREEN,
            width: 0.35,
          ),
          RangeColumnSeries<_ChartData, num>(
            dataSource: data,
            legendIconType: LegendIconType.circle,
            xValueMapper: (_ChartData sales, _) => sales.x,
            lowValueMapper: (_ChartData sales, _) => sales.y,
            highValueMapper: (_ChartData sales, _) => sales.a,
            color: AppColors.THEME_COLOR_LIGHT_GREEN,
            width: 0.35,
          ),
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y, this.z, this.a);
  final double x;
  final double y;
  final double z;
  final double a;
}
