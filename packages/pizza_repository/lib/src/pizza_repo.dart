import 'models/pizza.dart';

abstract class PizzaRepo {
  Future<List<Pizza>> getPizzas();
}
