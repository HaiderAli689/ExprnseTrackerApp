import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker_app/models/expense.dart' as Category;

import '../models/expense.dart';

final formatter = DateFormat.yMd();


class NewExpense extends StatefulWidget {
  const NewExpense({Key? key, required this.onAddExpence}) : super(key: key);

  final void Function(Expense expence) onAddExpence;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category.Category _selectedCategory = Category.Category.leisure;

  void _presentdataPicker() async{
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1, now.month, now.day);
    final pickedDate =  await showDatePicker(context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now,

    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog(){
    if(Platform.isIOS){
      showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
        title: Text("Invalid Input"),
        content: Text("Please make sure enter a valid things!"),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Okay")),


        ],
      ));
    }
    else{
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Invalid Input"),
              content: Text("Please make sure enter a valid things!"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text("Okay")),


              ],

            ),
      );
    }

  }

  void _submitExpenseData(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpence(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        category: _selectedCategory,
        date: _selectedDate!)
    );
    Navigator.pop(context);

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(builder: (context, constraints){
     /* print(constraints.maxHeight);
      print(constraints.minHeight);
      print(constraints.maxWidth);
      print(constraints.minWidth);*/

      final width = constraints.maxWidth;

      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if(width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

            Expanded(
              child: TextField(
              controller: _titleController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                label: Text("Title"),

              ),
          ),
            ),
                      SizedBox(width: 24,),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixText: "\$ ",
                            label: Text("Amount"),

                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: Text("Title"),

                    ),
                  ),
                if(width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.Category.values.map(
                                (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category.name.toUpperCase()))
                        ).toList(),
                        onChanged: (value){
                          setState(() {
                            if(value == null){
                              return ;
                            }
                            _selectedCategory = value;
                          });
                        },),
                      SizedBox(width: 24,),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(_selectedDate == null ?"No Selected Date": formatter.format(_selectedDate!)),
                            IconButton(onPressed: _presentdataPicker,
                                icon: Icon(Icons.calendar_month))
                          ],
                        ),
                      )
                    ],
                  )
                else
                  Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: "\$ ",
                          label: Text("Amount"),

                        ),
                      ),
                    ),
                    SizedBox(width: 16,),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null ?"No Selected Date": formatter.format(_selectedDate!)),
                          IconButton(onPressed: _presentdataPicker,
                              icon: Icon(Icons.calendar_month))
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16,),
                if(width >= 600)
                  Row(
                    children: [
                      Spacer(),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          child: Text("Cancel")),
                      ElevatedButton(onPressed: _submitExpenseData,
                          child: Text("Save Expense"))
                    ],
                  )
                else
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.Category.values.map(
                              (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category.name.toUpperCase()))
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          if(value == null){
                            return ;
                          }
                          _selectedCategory = value;
                        });
                      },),
                    Spacer(),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    },
                        child: Text("Cancel")),
                    ElevatedButton(onPressed: _submitExpenseData,
                        child: Text("Save Expense"))
                  ],
                )
              ],
            ),),
        ),
      );

    });
  }
}
