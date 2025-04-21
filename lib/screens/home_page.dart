import 'package:flutter/material.dart';

import 'coffee_list.dart';
import 'filter_list.dart';
import 'history_page.dart';
import 'statistics_page.dart';
import 'users_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista do Café',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorWeight: 4,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.coffee,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Café'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.filter_alt,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Filtro'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Estatísticas'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Histórico'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Usuários'),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CoffeeList(),
            FilterList(),
            StatisticsPage(),
            HistoryPage(),
            UsersPage(),
          ],
        ),
      ),
    );
  }
}
