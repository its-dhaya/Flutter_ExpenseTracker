import 'package:flutter/material.dart';
import 'package:project/data/hivedata.dart';
import 'package:project/datetime/datetimehelp.dart';
import 'package:project/models/expenseitem.dart';

class ExpenseData extends ChangeNotifier {
  // List the expenses
  List<ExpenseItem> overallExpensList = [];

  List<ExpenseItem> getallExpenseList() {
    return overallExpensList;
  }

  final db = HiveDataBase();

  void perpareData() {
    if (db.readData().isNotEmpty) {
      overallExpensList = db.readData();
    }
  }

  // Add new expense
  void addnewExpense(ExpenseItem newExpense) {
    overallExpensList.add(newExpense);
    notifyListeners();
    db.saveData(overallExpensList);
  }

  // Delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpensList.remove(expense);
    notifyListeners();
    db.saveData(overallExpensList);
  }

  // Weekly data
  String getDayname(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return ' ';
    }
  }

  DateTime startofWeekData() {
    DateTime? startofWeek;

    DateTime today = DateTime.now();

    for (int i = 0; i < 7; i++) {
      if (getDayname(today.subtract(Duration(days: i))) == "SUN") {
        startofWeek = today.subtract(Duration(days: i));
      }
    }
    return startofWeek!;
  }

  Map<String, double> calculateDailyExpense() {
    Map<String, double> dailyexpense = {};

    for (var expense in overallExpensList) {
      String date = convertDateTimetoString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyexpense.containsKey(date)) {
        double currentAmount = dailyexpense[date]!;
        currentAmount += amount;
        dailyexpense[date] = currentAmount;
      } else {
        dailyexpense.addAll({date: amount});
      }
    }
    return dailyexpense;
  }

  // Add new income
  void addnewIncome(String amount) {
    DateTime now = DateTime.now();
    overallExpensList.add(ExpenseItem(
      name: 'Income',
      amount: amount,
      dateTime: now,
    ));
    notifyListeners();
    db.saveData(overallExpensList);
  }

  // Calculate income total
  double calculateIncomeTotal() {
    double total = 0;
    for (var expense in overallExpensList) {
      if (expense.name == 'Income') {
        total += double.parse(expense.amount!);
      }
    }
    return total;
  }
}
