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
  // Get the current date and time
  DateTime now = DateTime.now();
  
  // Remove the existing 'Income' expense item, if any
  overallExpensList.removeWhere((expense) => expense.name == 'Income');
  
  // Create a new 'Income' expense item with the updated amount and current date/time
  ExpenseItem newIncome = ExpenseItem(
    name: 'Income',
    amount: amount,
    dateTime: now,
  );

  // Add the new 'Income' expense item to the list
  overallExpensList.add(newIncome);

  // Persist the updated list (overallExpensList) to the data source (e.g., SharedPreferences, database)
  db.saveData(overallExpensList);

  // Notify listeners to update the UI
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
  // Get the current total income
  double currentIncome = calculateIncomeTotal();
  
  // Parse the deducted amount
  double deductedAmount = double.tryParse(amount) ?? 0; // Add error handling if necessary
  
  // Calculate the new income after deduction
  double newIncome = currentIncome - deductedAmount;

  // Find the index of the existing 'Income' item in the list
  int index = overallExpensList.indexWhere((expense) => expense.name == 'Income');

  if (index != -1) {
    // Update the amount of the existing 'Income' item
    overallExpensList[index].amount = newIncome.toString();
    
    // Optionally, update the dateTime of the 'Income' item to reflect the time of the deduction
    overallExpensList[index].dateTime = DateTime.now();
  } else {
    // If 'Income' item doesn't exist, add a new one with the updated amount
    overallExpensList.add(ExpenseItem(
      name: 'Income',
      amount: newIncome.toString(),
      dateTime: DateTime.now(),
    ));
  }

  // Notify listeners after updating the expense list
  notifyListeners();
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

    // Check if the edited expense is an income
    if (text == 'Income') {
      // Calculate the new income total
      double newIncome = overallExpensList
          .where((item) => item.name == 'Income')
          .map((item) => double.tryParse(item.amount) ?? 0)
          .fold(0, (prev, curr) => prev + curr);

      // Deduct the new income from the overall expenses
      double totalExpenses = overallExpensList
          .where((item) => item.name != 'Income')
          .map((item) => double.tryParse(item.amount) ?? 0)
          .fold(0, (prev, curr) => prev + curr);

      double remainingIncome = newIncome - totalExpenses;

      // Update the income item with the new total
      overallExpensList.removeWhere((item) => item.name == 'Income');
      overallExpensList.add(ExpenseItem(
        name: 'Income',
        amount: newIncome.toString(),
        dateTime: DateTime.now(),
      ));

      // Notify listeners to update the UI
      notifyListeners();

      return;
    }

    // Save the updated list to your data source
    db.saveData(overallExpensList);
    
    // Notify listeners to update the UI
    notifyListeners();
  }
}


}