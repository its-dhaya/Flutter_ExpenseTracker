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
  void addNewExpense(ExpenseItem newExpense) {
    overallExpensList.insert(0,newExpense);
    if (newExpense.name != 'Income') {
      db.saveData(overallExpensList);
    } else {
      deductIncome(newExpense.amount);
    }
    notifyListeners();
  }

  // Delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpensList.remove(expense);
    if (expense.name != 'Income') {
      db.saveData(overallExpensList);
    }
    notifyListeners();
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
    Map<String, double> dailyExpense = {};

    for (var expense in overallExpensList) {
      if (expense.name != 'Income') {
        String date = convertDateTimetoString(expense.dateTime);
        double amount = double.parse(expense.amount);

        if (dailyExpense.containsKey(date)) {
          double currentAmount = dailyExpense[date]!;
          currentAmount += amount;
          dailyExpense[date] = currentAmount;
        } else {
          dailyExpense.addAll({date: amount});
        }
      }
    }
    return dailyExpense;
  }

  // Add new income
  void addNewIncome(String amount) {
    DateTime now = DateTime.now();
    overallExpensList.removeWhere((expense) => expense.name == 'Income');
    ExpenseItem newIncome = ExpenseItem(
      name: 'Income',
      amount: amount,
      dateTime: now,
    );

    overallExpensList.add(newIncome);
    notifyListeners();
  }

  // Calculate income total
  double calculateIncomeTotal() {
    double total = 0;
    for (var expense in overallExpensList) {
      if (expense.name == 'Income') {
        total += double.parse(expense.amount);
      }
    }
    return total;
  }

void deductIncome(String amount) {
  double currentIncome = calculateIncomeTotal();
  double deductedAmount = double.tryParse(amount) ?? 0; // Add error handling
  double newIncome = currentIncome - deductedAmount;

  overallExpensList.removeWhere((expense) => expense.name == 'Income');
  overallExpensList.add(ExpenseItem(
    name: 'Income',
    amount: newIncome.toString(),
    dateTime: DateTime.now(),
  ));

  notifyListeners(); // Notify listeners after updating the expense list
}

  void editExpense(ExpenseItem expense, String text, String amount) {
  // Find the index of the expense item in the list
  int index = overallExpensList.indexOf(expense);
  
  if (index != -1) { // Check if the expense item exists in the list
    // Update the properties of the expense item
    overallExpensList[index] = ExpenseItem(
      name: text,
      amount: amount,
      dateTime: expense.dateTime,
    );
    
    // Save the updated list to your data source
    db.saveData(overallExpensList);
    
    // Notify listeners to update the UI
    notifyListeners();
  }
}

}