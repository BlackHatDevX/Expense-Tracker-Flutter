import 'package:expense_app/widgets/chart/chart.dart';
import 'package:expense_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/widgets/new_expense.dart';

import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 10.99,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void addExpense(Expense expenseData) {
    setState(() {
      _registeredExpenses.add(expenseData);
    });
  }

  void removeExpense(Expense expenseData) {
    int removedExpenseIndex = _registeredExpenses.indexOf(expenseData);
    setState(() {
      _registeredExpenses.remove(expenseData);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Expense Deleted"),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(removedExpenseIndex, expenseData);
              });
            }),
      ),
    );
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(addNewExpense: addExpense));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registeredExpenses),
          Expanded(
              child: _registeredExpenses.isNotEmpty
                  ? ExpensesList(
                      expenses: _registeredExpenses,
                      deleteExpense: removeExpense)
                  : const Center(
                      child: Text(
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                          "No expenses found. \nStart adding some!"))),
        ],
      ),
    );
  }
}
