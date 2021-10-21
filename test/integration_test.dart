import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:testing_app/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Test', () {
    testWidgets('Favorite Persistance Between Screens', (tester) async {
      await tester.pumpWidget(const ColorPickerApp());

      Finder listView = find.byType(ListView);

      expect(listView, findsOneWidget,
          reason: 'List view is initialized on startup');

      // simulate favorite
      await tester.tap(find.byIcon(Icons.favorite_border).at(1));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget,
          reason: 'Can favorite an item');

      // favorite another item for later testing
      await tester.tap(find.byIcon(Icons.favorite_border).at(1));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsNWidgets(2),
          reason: 'Ensure two items are favorited');

      // simulate unfavorite of first item
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle();

      // can unfavorite an item from HomePage
      expect(find.byIcon(Icons.favorite), findsOneWidget,
          reason: 'Can unfavorite an item from HomePage');

      // simulate switch to FavoritesPage
      await tester.tap(find.byIcon(Icons.favorite_border_outlined).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // clicking the list icon switches to FavoritesPage
      expect(find.byIcon(Icons.arrow_back), findsOneWidget,
          reason: 'Back button is present on FavoritesPage');

      expect(find.byIcon(Icons.favorite), findsOneWidget,
          reason: 'FavoritesPage should list one item');

      // simulate removing item from favorites
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle();

      // can unfavorite an item from FavoritesPage
      expect(find.byIcon(Icons.favorite), findsNothing,
          reason: 'Unfavorite an item from FavoritesPage');

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pumpAndSettle();

      // BackButton goes back to HomePage
      expect(find.text('Color Picker'), findsOneWidget,
          reason: 'Back button returns to HomePage');

      // unfavoriting an item on the FavoritesPage reflects the change on HomePage
      expect(find.byIcon(Icons.favorite), findsNothing,
          reason: 'Ensure unfavoriting persists from FavoritesPage');

      // simulate favoriting again
      await tester.tap(find.byIcon(Icons.favorite_border).at(1));
      // simulate scrolling
      await tester.fling(listView, const Offset(0, -200), 3000);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });
}
