
import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expense_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _registerExpenses = [
    Expense(title: 'Flutter Course ',
        amount: 99.99,
        category: Category.work,
        date: DateTime.now()),

    Expense(title: 'Cinema Thug ',
        amount: 89.98,
        category: Category.leisure,
        date: DateTime.now()),

  ];

  void _openAddExpenseOverLay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
        context: context,
        builder: (context){
          return NewExpense(onAddExpence: _addExpense);
        });
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
            content: Text("Expense Deleted."),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: (){
          setState(() {
            _registerExpenses.insert(expenseIndex, expense);
          });
            }),
        ));
  }



  void _addExpense(Expense expense){
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {

    // to check the full screens height and width
   /* print(MediaQuery.of(context).size.height);
    print(MediaQuery.of(context).size.width);*/

    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(child: Text("No expense found. Start adding some!"),);
    if(_registerExpenses.isNotEmpty){
      mainContent =ExpenseList(expenses: _registerExpenses,
        onRemovedExpense: _removeExpense,);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Expense Tracker"),
        actions: [
          IconButton(onPressed: _openAddExpenseOverLay,
              icon: Icon(Icons.add))
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _registerExpenses),
          Expanded(
              child: mainContent ),
        ],
      ) : Row(
        children: [
          Expanded(
              child: Chart(expenses: _registerExpenses)),
          Expanded(
              child: mainContent ),
        ],
      ),
    );
  }
}
