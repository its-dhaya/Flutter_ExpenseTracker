import 'package:project/bargarph/individualbar.dart';

class BarData{
  final double sunamount;
  final double monamount;
  final double tueamount;
  final double wedamount;
  final double thuamount;
  final double friamount;
  final double satmount;


  BarData({
    required this.sunamount,
    required this.monamount,
    required this.tueamount,
    required this.wedamount,
    required this.thuamount,
    required this.friamount,
    required this.satmount
  });

  List<IndividualBar> barData=[];
  void   Initialize(){
    barData=[
      IndividualBar(x: 0,y: sunamount),

      IndividualBar(x: 1,y: monamount),

      IndividualBar(x: 2,y: tueamount),

      IndividualBar(x: 3,y: wedamount),

      IndividualBar(x: 4,y: thuamount),

      IndividualBar(x: 5,y: friamount),

      IndividualBar(x: 6,y: satmount),

      

    ];
  }



}