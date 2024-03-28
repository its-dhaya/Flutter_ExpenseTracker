import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:project/bargarph/bardata.dart";

class MyBarGraph extends StatelessWidget {
  final double maxY;
  final double sunamount;
  final double monamount;
  final double tueamount;
  final double wedamount;
  final double thuamount;
  final double friamount;
  final double satmount;



  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunamount,
    required this.monamount,
    required this.tueamount,
    required this.wedamount,
    required this.thuamount,
    required this.friamount,
    required this.satmount
    });

  @override
  Widget build(BuildContext context) {

    BarData myBarData=BarData(
      sunamount: sunamount, 
      monamount: monamount, 
      tueamount: tueamount,
       wedamount: wedamount, 
       thuamount: thuamount, 
       friamount: friamount,
        satmount: satmount);
      myBarData.Initialize();


    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      titlesData:  const FlTitlesData(show: true,
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: getBottomTitles,
        reservedSize: 24
      ))
      ),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: myBarData.barData.map(
        (data) => BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(toY: data.y,
            color: Colors.blueGrey.shade400,
            width: 21,
            borderRadius: BorderRadius.circular(5),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              color: Colors.grey.shade200,
              toY: maxY,)
            ),
            
            
          ]
          ),
          )
          .toList(),
    )
    );
  }
}
Widget getBottomTitles(double value,TitleMeta meta){
  const style= TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  Widget text;
  switch(value.toInt()){
    case 0:
      text =const Text('S',style: style,);
      break;
    case 1:
      text =const Text('M',style: style,);
      break;
    case 2:
      text =const Text('T',style: style,);
      break;
     case 3:
      text =const Text('W',style: style,);
      break;
     case 4:
      text =const Text('T',style: style,);
      break;
     case 5:
      text =const Text('F',style: style,);
      break;   
    case 6:
      text =const Text('S',style: style,);
      break;

    default:

      text =const Text(' ',style: style,);
      break;
  }
  return SideTitleWidget(
    child: text,
     axisSide: meta.axisSide);

}