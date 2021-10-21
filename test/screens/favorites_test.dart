import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/screens/favorites.dart';

late Favorites favoritesList;

Widget createFavoriteScreen() {
  return ChangeNotifierProvider<Favorites>(
    create: (context) {
      favoritesList = Favorites();
      return favoritesList;
    },
    child: const MaterialApp(
      home: FavoritesPage(),
    ),
  );
}

void addFavorites() {
  for (int i = 0; i < 6; i++) {
    favoritesList.add(i);
  }
}

void main() {
  group('Favorites Page Widget Tests:', () {
    testWidgets('Testing if ListView shows up', (tester) async {
      await tester.pumpWidget(createFavoriteScreen());
      addFavorites();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Testing remove button', (tester) async {
      await tester.pumpWidget(createFavoriteScreen());
      addFavorites();
      await tester.pumpAndSettle();

      int favoritesLength =
          tester.widgetList(find.byIcon(Icons.favorite)).length;

      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(tester.widgetList(find.byIcon(Icons.favorite)).length,
          lessThan(favoritesLength));

      expect(find.text('Removed from favorites'), findsOneWidget);
    });
  });
}
