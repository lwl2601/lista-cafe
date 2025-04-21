import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contribution.dart';
import '../models/user.dart';

class CoffeeService extends ChangeNotifier {
  List<User> _users = [];
  int _totalCoffeeContributions = 0;
  int _totalFilterContributions = 0;
  int _monthlyCoffeeContributions = 0;
  int _monthlyFilterContributions = 0;

  List<User> get users => _users;
  int get totalCoffeeContributions => _totalCoffeeContributions;
  int get totalFilterContributions => _totalFilterContributions;
  int get monthlyCoffeeContributions => _monthlyCoffeeContributions;
  int get monthlyFilterContributions => _monthlyFilterContributions;

  List<Contribution> get history {
    final allContributions = _users.expand((user) => user.history).toList();
    allContributions.sort((a, b) => b.date.compareTo(a.date));
    return allContributions;
  }

  CoffeeService() {
    _loadData().then((_) {
      if (_users.isEmpty) {
        _users = [
          User(name: 'André'),
          User(name: 'José'),
          User(name: 'Léo'),
          User(name: 'Carlos'),
          User(name: 'Kauan'),
          User(name: 'Mateus'),
          User(name: 'Henrique'),
          User(name: 'João'),
        ];
        _saveData();
      }
    });
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Carregar usuários
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final List<dynamic> usersData = json.decode(usersJson);
      _users = usersData.map((data) => User.fromJson(data)).toList();
    }

    // Carregar contagens
    _totalCoffeeContributions = prefs.getInt('totalCoffeeContributions') ?? 0;
    _totalFilterContributions = prefs.getInt('totalFilterContributions') ?? 0;
    _monthlyCoffeeContributions =
        prefs.getInt('monthlyCoffeeContributions') ?? 0;
    _monthlyFilterContributions =
        prefs.getInt('monthlyFilterContributions') ?? 0;

    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Salvar usuários
    final usersJson = json.encode(_users.map((user) => user.toJson()).toList());
    await prefs.setString('users', usersJson);

    // Salvar contagens
    await prefs.setInt('totalCoffeeContributions', _totalCoffeeContributions);
    await prefs.setInt('totalFilterContributions', _totalFilterContributions);
    await prefs.setInt(
        'monthlyCoffeeContributions', _monthlyCoffeeContributions);
    await prefs.setInt(
        'monthlyFilterContributions', _monthlyFilterContributions);
  }

  User? get nextCoffeeContributor {
    if (_users.isEmpty) return null;
    return _users.reduce(
      (a, b) => a.coffeeContributions < b.coffeeContributions ? a : b,
    );
  }

  User? get nextFilterContributor {
    if (_users.isEmpty) return null;
    return _users.reduce(
      (a, b) => a.filterContributions < b.filterContributions ? a : b,
    );
  }

  void addUser(String name) {
    if (_users.any((user) => user.name == name)) {
      throw Exception('Usuário já existe');
    }
    _users.add(User(name: name));
    _saveData();
    notifyListeners();
  }

  void removeUser(String name) {
    _users.removeWhere((user) => user.name == name);
    _saveData();
    notifyListeners();
  }

  void addCoffeeContribution(String userName) {
    final user = _users.firstWhere((user) => user.name == userName);
    user.incrementCoffeeContribution();
    _totalCoffeeContributions++;
    _monthlyCoffeeContributions++;
    _saveData();
    notifyListeners();
  }

  void addFilterContribution(String userName) {
    final user = _users.firstWhere((user) => user.name == userName);
    user.incrementFilterContribution();
    _totalFilterContributions++;
    _monthlyFilterContributions++;
    _saveData();
    notifyListeners();
  }

  void addContribution(
      String userName, String item, int quantity, DateTime date) {
    final user = _users.firstWhere((user) => user.name == userName);
    user.history.add(Contribution(date: date, item: item, quantity: quantity));

    if (item == 'Café') {
      user.coffeeContributions += quantity;
      _totalCoffeeContributions += quantity;
      if (date.month == DateTime.now().month &&
          date.year == DateTime.now().year) {
        _monthlyCoffeeContributions += quantity;
      }
    } else if (item == 'Filtro') {
      user.filterContributions += quantity;
      _totalFilterContributions += quantity;
      if (date.month == DateTime.now().month &&
          date.year == DateTime.now().year) {
        _monthlyFilterContributions += quantity;
      }
    }

    _saveData();
    notifyListeners();
  }
}
