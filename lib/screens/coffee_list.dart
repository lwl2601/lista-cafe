import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/coffee_service.dart';

class CoffeeList extends StatefulWidget {
  const CoffeeList({super.key});

  @override
  State<CoffeeList> createState() => _CoffeeListState();
}

class _CoffeeListState extends State<CoffeeList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final coffeeService = context.watch<CoffeeService>();
    final users = coffeeService.users;
    final nextContributor = users.isNotEmpty ? users[_currentIndex] : null;

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
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.coffee,
                        size: 40,
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lista atualizada com sucesso!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Próximo a contribuir com café:',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    nextContributor?.name ?? 'Ninguém',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Contribuições: ${nextContributor?.coffeeContributions ?? 0}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: users.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _currentIndex =
                                      (_currentIndex - 1) % users.length;
                                });
                              },
                        icon: const Icon(Icons.arrow_back_ios,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: users.isEmpty
                            ? null
                            : () {
                                setState(() {
                                  _currentIndex =
                                      (_currentIndex + 1) % users.length;
                                });
                              },
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: coffeeService.users.length,
              itemBuilder: (context, index) {
                final user = coffeeService.users[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          user.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contribuições: ${user.coffeeContributions}'),
                          Text(
                            'Este mês: ${user.getMonthlyContributions('Café')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          coffeeService.addCoffeeContribution(user.name);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Contribuir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
