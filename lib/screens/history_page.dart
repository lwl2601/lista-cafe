import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/coffee_service.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeService = context.watch<CoffeeService>();
    final history = coffeeService.history;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.background,
            Theme.of(context).colorScheme.background.withOpacity(0.8),
          ],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          final date = DateFormat('dd/MM/yyyy HH:mm').format(item.date);
          final icon = item.type == 'Café' ? Icons.coffee : Icons.filter_alt;

          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              title: Text(
                item.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Contribuiu com ${item.type}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              trailing: Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
