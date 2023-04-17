import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/widget/bar_chart.dart';
import '../model/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> resentTransaction;

  Chart(this.resentTransaction);

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (previousValue, element) => previousValue + element['amount']);
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      for (var i = 0; i < resentTransaction.length; i++) {
        if (resentTransaction[i].date.day == weekDay.day &&
            resentTransaction[i].date.month == weekDay.month &&
            resentTransaction[i].date.year == weekDay.year) {
          totalSum += resentTransaction[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues
              .map((e) => Flexible(
                    fit: FlexFit.tight,
                    child: BarChart(
                      label: e['day'],
                      spendingAmount: e['amount'],
                      spendingPercentTotal: totalSpending == 0.0
                          ? 0.0
                          : (e['amount'] as double) / totalSpending,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
