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
    required String incomeAmount,
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
  //values to show the deducted income
    values.removeWhere((amount) => amount < 0);
    double total = values.reduce((value, element) => value + element);
    return total.round().toString();
  }

  String calculateIncomeTotal(ExpenseData value) {
    double incomeTotal = value.calculateIncomeTotal();
    return incomeTotal.round().toString(); // returning incomeTotal as integer
  }

  String calculateRemainingIncome(ExpenseData value) {
    double incomeTotal = value.calculateIncomeTotal();
    double totalExpenses = double.parse(calculateWeektotal(
      value,
      convertDateTimetoString(startofWeek.add(const Duration(days: 0))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 1))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 2))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 3))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 4))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 5))),
      convertDateTimetoString(startofWeek.add(const Duration(days: 6))),
    ));
    double remainingIncome = incomeTotal - totalExpenses;
    return remainingIncome.round().toString();
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
      builder: (context, value, child) {
        String remainingIncome = calculateRemainingIncome(value);
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Weekly Total:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '₹${calculateWeektotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(243, 255, 255, 255),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Remaining Income:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '₹$remainingIncome',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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
        );
      },
    );
  }
}
