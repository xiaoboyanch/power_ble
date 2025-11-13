import 'package:cabina_ble/base_views/rh_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PowerLineSingleChart extends StatefulWidget {
  PowerLineSingleChart({super.key, required this.list1});
  List<FlSpot> dataSpot1 = [];
  List<double> list1;
  List<Color> gradientColors = [
    RHColor.contentColorLightPink,
    RHColor.contentColorDarkPink,
  ];
  @override
  State<PowerLineSingleChart> createState() => _PowerLineChartState();
}

class _PowerLineChartState extends State<PowerLineSingleChart> {
  @override
  Widget build(BuildContext context) {
    widget.dataSpot1.clear();
    for (int i = 0; i < widget.list1.length; i++) {
      var y = widget.list1[i];
      widget.dataSpot1.add(FlSpot(i.toDouble(), y));
    }
    return LineChart(
        duration: const Duration(milliseconds: 0),
        sampledData1
    );
  }

  LineChartData get sampledData1 => LineChartData(
    minY: 0,
    maxY: 900,
    baselineY: 0,
    lineBarsData: randomLineData,
    gridData: const FlGridData(
      show: false,
    ),
    titlesData: const FlTitlesData(
      show: true,
      leftTitles:  AxisTitles(drawBelowEverything: false),
      topTitles:  AxisTitles(drawBelowEverything: false),
      bottomTitles:  AxisTitles(drawBelowEverything: false),
      rightTitles: AxisTitles(
        drawBelowEverything: false,
      ),
    ),
    borderData: FlBorderData(
        show: false
    ),
    lineTouchData: LineTouchData(enabled: false),
  );

  List<LineChartBarData> get randomLineData =>
      [randomLineData1];

  LineChartBarData get randomLineData1 => LineChartBarData(
    isCurved: true,
    color: RHColor.line_1,
    // gradient: LinearGradient(
    //   colors: [
    //     ColorTween(begin: widget.gradientColors[0], end: widget.gradientColors[1])
    //         .lerp(0.2)!,
    //     ColorTween(begin: widget.gradientColors[0], end: widget.gradientColors[1])
    //         .lerp(0.2)!,
    //   ],
    // ),
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    //防止曲线超出数据范围
    belowBarData: BarAreaData(
      show: false,
      // gradient: LinearGradient(
      //   colors: [
      //     ColorTween(begin: widget.gradientColors[0], end: widget.gradientColors[1])
      //         .lerp(0.2)!
      //         .withOpacity(0.1),
      //     ColorTween(begin: widget.gradientColors[0], end: widget.gradientColors[1])
      //         .lerp(0.2)!
      //         .withOpacity(0.1),
      //   ],
      // ),
    ),
    spots: widget.dataSpot1,
  );

}


