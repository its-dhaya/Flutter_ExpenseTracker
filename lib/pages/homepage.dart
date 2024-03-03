import 'package:flutter/material.dart';
import 'package:project/components/expensesummary.dart';
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
  String incomeAmount = "";

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).perpareData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Walletly',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 188,
                child: DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Income!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('AMOUNT: ₹$incomeAmount', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: () => editIncome(context),
                          ),
                        ],
                        
                      ),
                      
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(
              height: 690,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: ExpenseSummary(
                        startofWeek: value.startofWeekData(),
                        incomeAmount: incomeAmount,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: value.getallExpenseList().length,
                        itemBuilder: (context, index) {
                          final expense = value.getallExpenseList()[index];
                          if (expense.name != 'Income') {
                            return ExpenseTile(
                              name: expense.name!,
                              amount: expense.amount!,
                              dateTime: expense.dateTime,
                              deleteTapped: (p0) => deleteExpense(expense),
                              editTapped: (p0) => editExpense(expense),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      padding: EdgeInsets.only(left: 5),
                      child: MaterialButton(
                        onPressed: addNewExpense,
                        color: Colors.black87,
                        textColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minWidth: 10,
                        height: 50,
                        child: Text('Add Expense'),
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

  void addNewExpense() {
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
          .addNewExpense(newExpense);
      Navigator.pop(context);
      clear();
    }
  }

  void editIncome(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Income'),
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
            onPressed: () => saveIncome(context),
            child: Text('Save'),
          )
        ],
      ),
    );
  }

  void saveIncome(BuildContext context) {
    if (newIncomeAmountController.text.isNotEmpty) {
      String amount = '${newIncomeAmountController.text}';
      setState(() {
        incomeAmount = amount;
      });
      Provider.of<ExpenseData>(context, listen: false)
          .addNewIncome(amount);
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
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ExpenseData>(context, listen: false)
                  .deleteExpense(expense);
              Navigator.pop(context);
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

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    newIncomeAmountController.clear();
  }
  
  void saveEditedExpense(BuildContext context, ExpenseItem expense) {}
}
