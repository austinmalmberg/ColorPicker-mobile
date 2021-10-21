import 'package:flutter_test/flutter_test.dart';
import 'package:testing_app/models/favorites.dart';

void main() {
  group('Testing App Provider', () {
    Favorites favorites = Favorites();

    test('A new item should be added', () {
      int number = 25;

      // execute test
      favorites.add(number);
      expect(favorites.items.contains(number), true);
    });

    test('An item should be removed', () {
      int number = 35;

      // setup test by adding the number
      favorites.add(number);
      expect(favorites.items.contains(number), true);

      // execute test
      favorites.remove(number);
      expect(favorites.items.contains(number), false);
    });
  });
}
