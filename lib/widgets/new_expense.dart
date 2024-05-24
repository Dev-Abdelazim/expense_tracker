import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {

  final _titleControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.work;

    /*
      Displays a date picker dialog and updates 
      the selected date when a date is picked.
      The function is asynchronous and must be marked with the `async` keyword.
      The `firstDate` parameter is set to one year ago from the current date, 
      and the `lastDate` parameter is set to the current date. The user can pick a date within this range.
    */
    void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year -1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context, 
      firstDate: firstDate, 
      lastDate: now
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // Displays an alert dialog with a title, content, and an "Ok" button.
  void _showAlertDialog(){
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context, 
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amout, date and category was entered...'
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(ctx); },
               child: const Text('Ok'),
            )
          ],
        )
      );
      
    }else{
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please make sure a valid title, amout, date and category was entered...'
          ),
          actions: [
            TextButton(
              onPressed: () { Navigator.pop(ctx); },
               child: const Text('Ok'),
            )
          ],
        )
      );
    }
  }

  void _submitExpenseData(){
    final entredAmount = double.tryParse(_amountControler.text);
    final amountIsInvalid = entredAmount == null || entredAmount <= 0;
    if (
      _titleControler.text.trim().isEmpty ||
      amountIsInvalid ||
      _selectedDate == null
    ) {
      _showAlertDialog();
      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleControler.text,
        amount: entredAmount,
        date: _selectedDate!,
        category: _selectedCategory
      )
    );

    Navigator.pop(context);

  }

  void _setSelectedCategory(Category? value){
    if (value == null) return;
      setState(() {
        _selectedCategory = value;
      });
  }



  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (
        (context, constraints) {
          final width = constraints.maxWidth;

          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 60, 16, keyboardSpace + 16), 
                child: Column(
                  children: [
                    if(width >= 600)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: TitleTextField(titleControler: _titleControler)),
                          const SizedBox(width: 24,),
                          AmountTextField(amountControler: _amountControler),
                        ],
                      )
                    else
                      TitleTextField(titleControler: _titleControler),  
                    
                    if(width >= 600)
                      Row(
                        children: [
                          CategoryDropDownMenu(
                            selectedCategory: _selectedCategory,
                            onSelectedCategory: _setSelectedCategory
                          ),

                          const SizedBox(width: 24,),

                          CustomDatePicker(
                            selectedDate: _selectedDate,
                            datePicker: _datePicker
                          ),
                        ],
                      )
                    else  
                      Row(
                        children: [
                          AmountTextField(amountControler: _amountControler),
                
                          const SizedBox(width: 16,),
                
                          CustomDatePicker(
                            selectedDate: _selectedDate,
                            datePicker: _datePicker
                          ),
                        ],
                      ),
              
                    const SizedBox(height: 16,),
                    
                    if(width >= 600)
                      Row(
                        children: [
                          const Spacer(),
                
                          const CancelButton(),
                
                          SaveExpenseButton(submitExpenseData: _submitExpenseData)
                        ],
                      )
                    else  
                      Row(
                        children: [
                          CategoryDropDownMenu(
                            selectedCategory: _selectedCategory,
                            onSelectedCategory: _setSelectedCategory
                          ),
                
                          const Spacer(),
                
                          const CancelButton(),
                
                          SaveExpenseButton(submitExpenseData: _submitExpenseData)
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        }
      )
    );
  }


  @override
  void dispose() {
    _titleControler.dispose();
    _amountControler.dispose();
    super.dispose();
  }
}


class TitleTextField extends StatelessWidget {
  const TitleTextField({super.key, required this.titleControler});
  
  final TextEditingController titleControler;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: titleControler,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text('Title'),
      ),
    );
  }
}

class AmountTextField extends StatelessWidget {
  const AmountTextField({super.key, required this.amountControler});

  final TextEditingController amountControler;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: TextField(
        controller: amountControler,
        decoration: const InputDecoration(
          prefixText: '\$ ',
          label: Text('amount')
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}


class CustomDatePicker extends StatelessWidget {
  const CustomDatePicker({
    super.key, 
    required this.selectedDate,
    required this.datePicker,
  });

  final DateTime? selectedDate;
  final void Function() datePicker;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              selectedDate == null
              ? 'Selected Date'
              : formatter.format(selectedDate!),
            ),
            IconButton(
              onPressed: datePicker,
              icon: const Icon(Icons.calendar_month),
          )
        ],
      ) 
    );
  }
}


class CategoryDropDownMenu extends StatelessWidget {
  const CategoryDropDownMenu({
    super.key,
    required this.selectedCategory,
    required this.onSelectedCategory
  });

  final Category selectedCategory;
  final void Function(Category? value) onSelectedCategory ;
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedCategory,
      items: Category.values.map(
        (category) => DropdownMenuItem(
        value: category,
        child: Text(category.name.toUpperCase()),
      )
      ).toList(), 
      onChanged: onSelectedCategory
    );
  }
}


class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel')
    );
  }
}


class SaveExpenseButton extends StatelessWidget {
  const SaveExpenseButton({super.key, required this.submitExpenseData});

  final void Function() submitExpenseData;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        submitExpenseData();
      }, 
      child: const Text('Save Expense'),
    );
  }
}