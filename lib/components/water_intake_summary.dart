import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/bars/bar_graph.dart';
import 'package:water_intake/data/water_data.dart';

class WaterSummary extends StatelessWidget {
  final DateTime startofWeek;

  const WaterSummary({super.key, required this.startofWeek});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterData>(
      builder: (context, value, child) => const SizedBox(
        height: 200,
        child: BarGraph(
            maxY: 100,
            sunWaterAmt: 50,
            monWaterAmt: 34,
            tueWaterAmt: 30,
            wedWaterAmt: 19,
            thurWaterAmt: 72,
            friWaterAmt: 71,
            satWaterAmt: 56),
      ),
    );
  }
}
