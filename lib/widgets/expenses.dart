import 'package:expense_tracker/widgets/char/char.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget{
  const Expenses({super.key});
  
  @override
  State<Expenses> createState() => _Expenses();
}

class _Expenses extends State<Expenses>{
  final List<Expense> _expenses = [
    Expense(
      title: 'My first expense', 
      amount: 50.02, 
      date: DateTime.now(), 
      category: Category.travel
    ),

    Expense(
      title: 'My Second expense', 
      amount: 100, 
      date: DateTime.now(), 
      category: Category.food
    ),
  ];


  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense,)
    );
  }

  void _showRemoveMassage(int index, Expense expense){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          '\'${expense.title}\' Successfully deleted.'
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            print('added suc');
            setState(() {
              _expenses.insert(index,expense);
            });
          },
        ),
      ),
    );
  }

  void _addExpense(Expense expense){
    setState(() {
      _expenses.add(expense);
    });
  }

  void _removeExpense(Expense expense){
    final index = _expenses.indexOf(expense);
    setState(() {
      _expenses.remove(expense);
    });
    
    ScaffoldMessenger.of(context).clearSnackBars;
    _showRemoveMassage(index, expense);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if(_expenses.isNotEmpty){
      mainContent = ExpensesList(
              expenses: _expenses,
              onRemoveExpense: _removeExpense,
            );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Expense Tracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _expenses),
          Expanded(
            child: mainContent,
          )
        ],
      ) : Row(children: [
          Expanded(child: Chart(expenses: _expenses)),
          Expanded(
            child: mainContent,
          )
      ],),
    );
  }
}