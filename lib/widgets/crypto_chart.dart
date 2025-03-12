import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CryptoChart extends StatelessWidget {
  final List<dynamic> priceData;

  CryptoChart({required this.priceData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.black)),
        lineBarsData: [
          LineChartBarData(
            spots: _getChartData(),
            isCurved: true,
            color: Colors.blue,
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getChartData() {
    List<FlSpot> chartData = [];
    for (int i = 0; i < priceData.length; i += 10) {
      chartData.add(FlSpot(i.toDouble(), priceData[i]));
    }
    return chartData;
  }
}
