
import 'package:expense_tracker_app/widgets/expense_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({Key? key, required this.expenses, required this.onRemovedExpense}) : super(key: key);

  final List<Expense> expenses ;
  final void Function(Expense expense) onRemovedExpense;


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length ,
        itemBuilder: (context, index)
        => Dismissible(
            key: ValueKey(expenses[index]),
        background: Container(color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),

        onDismissed: (direction){
          onRemovedExpense(expenses[index]);
        },
        child: ExpenseListItem(expense: expenses[index])
        )
    );
  }
}
