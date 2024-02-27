import "package:hive_flutter/hive_flutter.dart";
import "package:hive/hive.dart";
import "package:project/models/expenseitem.dart";


class HiveDataBase{
  final _myBox = Hive.box("expense_database");

  void saveData(List<ExpenseItem> allExpense){



    List<List<dynamic>> allExpenseFormatted=[];
    for(var expense in allExpense){
      List<dynamic> expenseFormatted=[
        expense.name,
        expense.amount,
        expense.dateTime,

      ];
      allExpenseFormatted.add(expenseFormatted);

    }
    _myBox.put("ALL_EXPENSES", allExpenseFormatted);

  }
  List<ExpenseItem> readData(){
    List savedExpense = _myBox.get("ALL_EXPENSES")??[];
    List<ExpenseItem> allExpense=[];
    for(int i =0;i<savedExpense.length;i++){
      String name = savedExpense[i][0];
      String amount = savedExpense[i][1];
      DateTime dateTime = savedExpense[i][2];

      ExpenseItem expense=
      ExpenseItem(name: name, amount: amount, dateTime: dateTime );

      allExpense.add(expense);
    }
    return allExpense;
  }

}