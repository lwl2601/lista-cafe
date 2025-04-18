import 'contribution.dart';

class User {
  final String name;
  int coffeeContributions;
  int filterContributions;
  List<Contribution> history;

  User({
    required this.name,
    this.coffeeContributions = 0,
    this.filterContributions = 0,
    List<Contribution>? history,
  }) : history = history ?? [];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      coffeeContributions: json['coffeeContributions'],
      filterContributions: json['filterContributions'],
      history: (json['history'] as List)
          .map((item) => Contribution.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'coffeeContributions': coffeeContributions,
      'filterContributions': filterContributions,
      'history': history.map((item) => item.toJson()).toList(),
    };
  }

  int getMonthlyContributions(String item) {
    final now = DateTime.now();
    return history
        .where((contribution) =>
            contribution.item == item &&
            contribution.date.month == now.month &&
            contribution.date.year == now.year)
        .fold(0, (sum, contribution) => sum + contribution.quantity);
  }

  void incrementCoffeeContribution() {
    coffeeContributions++;
    history.add(Contribution(
      date: DateTime.now(),
      item: 'Café',
      quantity: 1,
    ));
  }

  void incrementFilterContribution() {
    filterContributions++;
    history.add(Contribution(
      date: DateTime.now(),
      item: 'Filtro',
      quantity: 1,
    ));
  }
}
