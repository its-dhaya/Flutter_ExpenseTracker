import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project/components/expensesummary.dart';
import 'package:project/components/expensetile.dart';
import 'package:project/data/expensedata.dart';
import 'package:project/models/expenseitem.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  @override
  void initState()  {
    super.initState();
    
    Provider.of<ExpenseData>(context, listen: false).perpareData();
  }

  void addnewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Expense name'),
              controller: newExpenseNameController,
            ),
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancel'),
          ),
          MaterialButton(
            onPressed: save,
            child: Text('Save'),
          )
        ],
      ),
    );
  }

  void deleteExpense(ExpenseItem expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Expense?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

void editExpense(ExpenseItem expense) {
  newExpenseNameController.text = expense.name ?? '';
  newExpenseAmountController.text = expense.amount ?? '';
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Edit Expense'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Expense name'),
            controller: newExpenseNameController,
          ),
          TextField(
            controller: newExpenseAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Amount',
            ),
          ),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: cancel,
          child: Text('Cancel'),
        ),
        MaterialButton(
          onPressed: () {
            saveEditedExpense(context, expense);
            Navigator.pop(context);
            clear();
          },
          child: Text('Save'),
        )
      ],
    ),
  );
}


  void save() {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      String amount = '${newExpenseAmountController.text}';
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now(),
      );
      Provider.of<ExpenseData>(context, listen: false)
          .addnewExpense(newExpense);
      Navigator.pop(context);
      clear();
    }
  }

void saveEditedExpense(BuildContext context, ExpenseItem expense) {
  if (newExpenseNameController.text.isNotEmpty &&
      newExpenseAmountController.text.isNotEmpty) {
    String amount = '${newExpenseAmountController.text}';
    // Update the existing expense item
    expense.name = newExpenseNameController.text;
    expense.amount = amount;
    expense.dateTime = DateTime.now();
    Provider.of<ExpenseData>(context, listen: false).notifyListeners(); // Notify listeners about the change
  }
}

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey.shade300,
        floatingActionButton: FloatingActionButton(
          onPressed: addnewExpense,
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: [
            ExpenseSummary(startofWeek: value.startofWeekData()),
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: value.getallExpenseList().length,
              itemBuilder: (context, index) => ExpensTile(
                name: value.getallExpenseList()[index].name!,
                amount: value.getallExpenseList()[index].amount!,
                dateTime: value.getallExpenseList()[index].dateTime,
                deleteTapped: (p0) =>
                    deleteExpense(value.getallExpenseList()[index]),
                editTapped: (p0) =>
                    editExpense(value.getallExpenseList()[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
