import 'package:flutter/material.dart';
import 'package:project/bargarph/bargraph.dart';
import 'package:project/data/expensedata.dart';
import 'package:project/datetime/datetimehelp.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startofWeek;

  const ExpenseSummary({
    Key? key,
    required this.startofWeek,
  }) : super(key: key);

  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;
    List<double> values = [
      value.calculateDailyExpense()[sunday] ?? 0,
      value.calculateDailyExpense()[monday] ?? 0,
      value.calculateDailyExpense()[tuesday] ?? 0,
      value.calculateDailyExpense()[wednesday] ?? 0,
      value.calculateDailyExpense()[thursday] ?? 0,
      value.calculateDailyExpense()[friday] ?? 0,
      value.calculateDailyExpense()[saturday] ?? 0,
    ];
    values.sort();
    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  String calculateWeektotal(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      value.calculateDailyExpense()[sunday] ?? 0,
      value.calculateDailyExpense()[monday] ?? 0,
      value.calculateDailyExpense()[tuesday] ?? 0,
      value.calculateDailyExpense()[wednesday] ?? 0,
      value.calculateDailyExpense()[thursday] ?? 0,
      value.calculateDailyExpense()[friday] ?? 0,
      value.calculateDailyExpense()[saturday] ?? 0,
    ];
    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimetoString(startofWeek.add(const Duration(days: 0)));
    String monday = convertDateTimetoString(startofWeek.add(const Duration(days: 1)));
    String tuesday = convertDateTimetoString(startofWeek.add(const Duration(days: 2)));
    String wednesday = convertDateTimetoString(startofWeek.add(const Duration(days: 3)));
    String thursday = convertDateTimetoString(startofWeek.add(const Duration(days: 4)));
    String friday = convertDateTimetoString(startofWeek.add(const Duration(days: 5)));
    String saturday = convertDateTimetoString(startofWeek.add(const Duration(days: 6)));
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Text(
                  "Weekly Total:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  '₹${calculateWeektotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: MyBarGraph(
              maxY: calculateMax(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday),
              sunamount: value.calculateDailyExpense()[sunday] ?? 0,
              monamount: value.calculateDailyExpense()[monday] ?? 0,
              tueamount: value.calculateDailyExpense()[tuesday] ?? 0,
              wedamount: value.calculateDailyExpense()[wednesday] ?? 0,
              thuamount: value.calculateDailyExpense()[thursday] ?? 0,
              friamount: value.calculateDailyExpense()[friday] ?? 0,
              satmount: value.calculateDailyExpense()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
