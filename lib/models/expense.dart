
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum Category{
  food,
  travel,
  leisure,
  work
}

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work
};


const _uuid = Uuid();
final formatter = DateFormat.yMd();
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  }): id = _uuid.v4();

  final String id;
  final String title; 
  final double amount;
  final DateTime date;
  final Category category; 

  String get formattedDate => formatter.format(date);
}

class ExpenseBucket{
  ExpenseBucket({required this.category, required this.expenses});
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
      .where((expense) => expense.category == category)
      .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses{
    double sum = 0;
    for (final element in expenses) { sum += element.amount; }
    return sum;
  }
}