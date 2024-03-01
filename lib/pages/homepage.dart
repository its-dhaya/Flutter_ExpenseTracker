import 'package:flutter/material.dart';
import '../components/expensesummary.dart';
import 'package:project/components/expensetile.dart';
import 'package:project/data/expensedata.dart';
import 'package:project/models/expenseitem.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  final newIncomeAmountController = TextEditingController();

  @override
  void initState() {
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
              decoration: const InputDecoration(hintText: 'Expense name'),
              controller: newExpenseNameController,
            ),
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Amount',
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
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

  void addIncome() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Income'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newIncomeAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Income amount',
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
            onPressed: saveIncome,
            child: Text('Save'),
          )
        ],
      ),
    );
  }

    void saveIncome() {
    if (newIncomeAmountController.text.isNotEmpty) {
      String amount = '${newIncomeAmountController.text}';
      // Add income item
      Provider.of<ExpenseData>(context, listen: false)
          .addnewIncome(amount);
      Navigator.pop(context);
      clear();
    }
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
              Provider.of<ExpenseData>(context, listen: false)
                  .deleteExpense(expense);
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


 

  void saveEditedExpense(BuildContext context, ExpenseItem expense) {
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      String amount = '${newExpenseAmountController.text}';
      // Update the existing expense item
      expense.name = newExpenseNameController.text;
      expense.amount = amount;
      expense.dateTime = DateTime.now();
      Provider.of<ExpenseData>(context, listen: false)
          .notifyListeners(); // Notify listeners about the change
    }
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    newIncomeAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return  Consumer<ExpenseData>(
          builder: (context, value, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey.shade300,
            body: Column(
              
              children: [
                SizedBox(
                  height: 695, // Adjust the height as needed
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(0),
                            
                          ),
                          child: ExpenseSummary(startofWeek: value.startofWeekData()),
                        ),
                        
                        Container(
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(0),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: value.getallExpenseList().length,
                            itemBuilder: (context, index) => ExpenseTile(
                              name: value.getallExpenseList()[index].name!,
                              amount: value.getallExpenseList()[index].amount!,
                              dateTime: value.getallExpenseList()[index].dateTime,
                              deleteTapped: (p0) =>
                                  deleteExpense(value.getallExpenseList()[index]),
                              editTapped: (p0) =>
                                  editExpense(value.getallExpenseList()[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
               // Adjust spacing as needed
                Container(
                  color: Colors.grey.shade300,
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.only(left: 10),
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {},
                            label: Text('Calculate',
                                style: TextStyle(color: Colors.white)),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 10,left: 10),
                          padding: EdgeInsets.only(left: 5),
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: addnewExpense,
                            label: Text('Add Expense',
                                style: TextStyle(color: Colors.white)),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          padding: EdgeInsets.only(right: 17,left: 18),
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: (){
                              addIncome();
                            },
                            label: Text('Income',
                                style: TextStyle(color: Colors.white)),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

  }
}
