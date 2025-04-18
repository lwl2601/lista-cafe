import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'services/coffee_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CoffeeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista do Café',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F5776),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

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

class CoffeeList extends StatefulWidget {
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

class FilterList extends StatefulWidget {
  @override
  State<FilterList> createState() => _FilterListState();
}

class _FilterListState extends State<FilterList> {
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
                        Icons.filter_alt,
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
                    'Próximo a contribuir com filtro:',
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
                    'Contribuições: ${nextContributor?.filterContributions ?? 0}',
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
                          Text('Contribuições: ${user.filterContributions}'),
                          Text(
                            'Este mês: ${user.getMonthlyContributions('Filtro')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () {
                          coffeeService.addFilterContribution(user.name);
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

class StatisticsPage extends StatefulWidget {
  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String _selectedPeriod = 'Mês';
  final List<String> _periods = ['Dia', 'Semana', 'Mês', 'Ano'];

  @override
  Widget build(BuildContext context) {
    final coffeeService = context.watch<CoffeeService>();

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildPeriodSelector(context),
            const SizedBox(height: 24),
            _buildMainStats(context, coffeeService),
            const SizedBox(height: 24),
            _buildTopContributors(context, coffeeService),
            const SizedBox(height: 24),
            _buildMonthlyChart(context, coffeeService),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Estatísticas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Análise detalhada das contribuições',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _periods.map((period) {
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMainStats(BuildContext context, CoffeeService coffeeService) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Café',
            coffeeService.totalCoffeeContributions.toString(),
            'Total de Contribuições',
            Icons.coffee,
            Colors.brown,
            coffeeService.monthlyCoffeeContributions.toString(),
            'Este Mês',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            'Filtro',
            coffeeService.totalFilterContributions.toString(),
            'Total de Contribuições',
            Icons.filter_alt,
            Colors.blue,
            coffeeService.monthlyFilterContributions.toString(),
            'Este Mês',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    String monthlyValue,
    String monthlyLabel,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    monthlyValue,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    monthlyLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopContributors(
      BuildContext context, CoffeeService coffeeService) {
    final topCoffeeContributors = List<User>.from(coffeeService.users)
      ..sort((a, b) => b.coffeeContributions.compareTo(a.coffeeContributions));
    final topFilterContributors = List<User>.from(coffeeService.users)
      ..sort((a, b) => b.filterContributions.compareTo(a.filterContributions));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Contribuintes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPodium(context, topCoffeeContributors, 'Café', Colors.brown),
          const SizedBox(height: 24),
          _buildPodium(context, topFilterContributors, 'Filtro', Colors.blue),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildContributorList(
                  context,
                  'Café',
                  topCoffeeContributors.take(3).toList(),
                  Colors.brown,
                  (user) => user.coffeeContributions,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildContributorList(
                  context,
                  'Filtro',
                  topFilterContributors.take(3).toList(),
                  Colors.blue,
                  (user) => user.filterContributions,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(
      BuildContext context, List<User> users, String title, Color color) {
    final top3 = users.take(3).toList();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.05),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              // Base do pódio
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              // Degraus do pódio
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (top3.length > 1) ...[
                      Expanded(
                        child: _buildPodiumStep(
                          context,
                          top3[1],
                          2,
                          color,
                          height: 120,
                          isSecond: true,
                        ),
                      ),
                    ],
                    Expanded(
                      child: _buildPodiumStep(
                        context,
                        top3[0],
                        1,
                        color,
                        height: 160,
                        isFirst: true,
                      ),
                    ),
                    if (top3.length > 2) ...[
                      Expanded(
                        child: _buildPodiumStep(
                          context,
                          top3[2],
                          3,
                          color,
                          height: 100,
                          isThird: true,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumStep(
    BuildContext context,
    User user,
    int position,
    Color color, {
    required double height,
    bool isFirst = false,
    bool isSecond = false,
    bool isThird = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Efeito de brilho
              if (isFirst)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.8),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Troféu com efeito
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _getTrophyColor(position, color).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getTrophyIcon(position),
                        color: _getTrophyColor(position, color),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Nome com efeito de destaque
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Posição com medalha
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            _getTrophyColor(position, color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getMedalIcon(position),
                            color: _getTrophyColor(position, color),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${position}º',
                            style: TextStyle(
                              color: _getTrophyColor(position, color),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Contribuições
                    const SizedBox(height: 8),
                    Text(
                      '${position == 1 ? user.coffeeContributions : user.filterContributions} contribuições',
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getTrophyIcon(int position) {
    switch (position) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.military_tech;
      default:
        return Icons.star;
    }
  }

  IconData _getMedalIcon(int position) {
    switch (position) {
      case 1:
        return Icons.workspace_premium;
      case 2:
        return Icons.workspace_premium;
      case 3:
        return Icons.workspace_premium;
      default:
        return Icons.star;
    }
  }

  Color _getTrophyColor(int position, Color baseColor) {
    switch (position) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return baseColor;
    }
  }

  Widget _buildContributorList(
    BuildContext context,
    String title,
    List<User> users,
    Color color,
    int Function(User) getContributions,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ...users.asMap().entries.map((entry) {
          final user = entry.value;
          final index = entry.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${getContributions(user)} contribuições',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Text(
                    user.name[0],
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMonthlyChart(BuildContext context, CoffeeService coffeeService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contribuições Mensais',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(
                  context,
                  'Jan',
                  coffeeService.monthlyCoffeeContributions.toDouble(),
                  Colors.brown,
                ),
                const SizedBox(width: 8),
                _buildChartBar(
                  context,
                  'Fev',
                  coffeeService.monthlyFilterContributions.toDouble(),
                  Colors.blue,
                ),
                const SizedBox(width: 8),
                _buildChartBar(
                  context,
                  'Mar',
                  (coffeeService.monthlyCoffeeContributions +
                          coffeeService.monthlyFilterContributions)
                      .toDouble(),
                  Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: value * 2,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? selectedUser;
  DateTime selectedDate = DateTime.now();
  String selectedItem = 'Café';
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final coffeeService = context.watch<CoffeeService>();

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Histórico de Contribuições',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedUser,
                      decoration: const InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                      items: coffeeService.users
                          .map((user) => DropdownMenuItem(
                                value: user.name,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUser = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedItem,
                      decoration: const InputDecoration(
                        labelText: 'Item',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Café', child: Text('Café')),
                        DropdownMenuItem(
                            value: 'Filtro', child: Text('Filtro')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: '1',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          quantity = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: selectedUser == null
                          ? null
                          : () {
                              coffeeService.addContribution(
                                selectedUser!,
                                selectedItem,
                                quantity,
                                selectedDate,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Contribuição adicionada com sucesso!'),
                                ),
                              );
                            },
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar ao Histórico'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Últimas Contribuições',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...(() {
                      final contributions = coffeeService.users
                          .expand((user) => user.history)
                          .toList()
                        ..sort((a, b) => b.date.compareTo(a.date))
                        ..take(10);

                      return contributions
                          .map((contribution) => ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  child: Text(
                                    contribution.item[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contribution.item,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${DateFormat('dd/MM/yyyy').format(contribution.date)} - Quantidade: ${contribution.quantity}',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    // Encontrar o usuário que fez a contribuição
                                    final user = coffeeService.users.firstWhere(
                                      (u) => u.history.contains(contribution),
                                    );
                                    // Remover a contribuição
                                    user.history.remove(contribution);
                                    // Atualizar as contagens
                                    if (contribution.item == 'Café') {
                                      user.coffeeContributions -=
                                          contribution.quantity;
                                    } else if (contribution.item == 'Filtro') {
                                      user.filterContributions -=
                                          contribution.quantity;
                                    }
                                    // Notificar a mudança
                                    coffeeService.notifyListeners();
                                    // Mostrar mensagem de sucesso
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Contribuição removida com sucesso!'),
                                      ),
                                    );
                                  },
                                ),
                              ))
                          .toList();
                    })(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _nameController = TextEditingController();
  String? selectedUser;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _reorderUsers(int oldIndex, int newIndex) {
    final coffeeService = context.read<CoffeeService>();
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final user = coffeeService.users.removeAt(oldIndex);
    coffeeService.users.insert(newIndex, user);
    coffeeService.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final coffeeService = context.watch<CoffeeService>();

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Adicionar Usuário',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Usuário',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        try {
                          coffeeService.addUser(_nameController.text);
                          _nameController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário adicionado com sucesso!'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Usuário já existe!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Adicionar Usuário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Remover Usuário',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedUser,
                      decoration: const InputDecoration(
                        labelText: 'Selecione o Usuário',
                        border: OutlineInputBorder(),
                      ),
                      items: coffeeService.users
                          .map((user) => DropdownMenuItem(
                                value: user.name,
                                child: Text(user.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUser = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: selectedUser == null
                          ? null
                          : () {
                              coffeeService.removeUser(selectedUser!);
                              setState(() {
                                selectedUser = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Usuário removido com sucesso!'),
                                ),
                              );
                            },
                      icon: const Icon(Icons.remove),
                      label: const Text('Remover Usuário'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Ordem dos Usuários',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Arraste os usuários para reordenar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: coffeeService.users.length,
                      onReorder: _reorderUsers,
                      itemBuilder: (context, index) {
                        final user = coffeeService.users[index];
                        return Container(
                          key: ValueKey(user.name),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
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
                            trailing: const Icon(
                              Icons.drag_handle,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
