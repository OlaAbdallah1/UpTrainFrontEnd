import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../../constants/colors.dart';

class Chart extends StatefulWidget {
  int numOfEmployees;
  int numOfCompanies;
  int numOfStudents;
  Chart(
      {super.key,
      required this.numOfCompanies,
      required this.numOfStudents,
      required this.numOfEmployees});
  @override
  // ignore: library_private_types_in_public_api
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: buildPieChartSectionData(),
            ),
          ),
        ],
      ),
    );
  }
List<PieChartSectionData> buildPieChartSectionData(){
List<PieChartSectionData> paiChartSelectionDatas = [
    PieChartSectionData(
      color: tPrimaryColor,
      value: widget.numOfCompanies.toDouble(),
      showTitle: false,
      radius: 25,
    ),
    PieChartSectionData(
      color: Color(0xFF26E5FF),
      value: widget.numOfCompanies.toDouble(),
      showTitle: false,
      radius: 22,
    ),
    PieChartSectionData(
      color: Color(0xFFFFCF26),
      value: widget.numOfEmployees.toDouble(),
      showTitle: false,
      radius: 19,
    ),
    PieChartSectionData(
      color: Color(0xFFEE2727),
      value: widget.numOfStudents.toDouble(),
      showTitle: false,
      radius: 16,
    ),
  
  ];

  return paiChartSelectionDatas;
}
}
