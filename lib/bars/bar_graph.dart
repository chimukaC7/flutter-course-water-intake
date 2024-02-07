import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:water_intake/bars/bar_data.dart';

class BarGraph extends StatelessWidget {
  final double maxY;
  final double sunWaterAmt;
  final double monWaterAmt;
  final double tueWaterAmt;
  final double wedWaterAmt;
  final double thurWaterAmt;
  final double friWaterAmt;
  final double satWaterAmt;

  const BarGraph(
      {super.key,
      required this.maxY,
      required this.sunWaterAmt,
      required this.monWaterAmt,
      required this.tueWaterAmt,
      required this.wedWaterAmt,
      required this.thurWaterAmt,
      required this.friWaterAmt,
      required this.satWaterAmt});

  @override
  Widget build(BuildContext context) {
    //initialize bardata
    BarData barData = BarData(
        sunWaterAmt: sunWaterAmt,
        monWaterAmt: monWaterAmt,
        tueWaterAmt: tueWaterAmt,
        wedWaterAmt: wedWaterAmt,
        thurWaterAmt: thurWaterAmt,
        friWaterAmt: friWaterAmt,
        satWaterAmt: satWaterAmt);

    barData.initBarData();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BarChart(BarChartData(
          maxY: maxY,
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false))),
          barGroups: barData.barData
              .map((data) => BarChartGroupData(x: data.x, barRods: [
                    BarChartRodData(
                        toY: data.y,
                        color: Colors.lightGreen[700],
                        width: 23,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        backDrawRodData: BackgroundBarChartRodData(
                            show: true, toY: maxY, color: Colors.grey[300]))
                  ]))
              .toList())),
    );
  }
}
