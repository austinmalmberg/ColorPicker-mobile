import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/screens/home.dart';

Widget createHomeScreen() {
  return ChangeNotifierProvider<Favorites>(
    create: (context) => Favorites(),
    child: const MaterialApp(
      home: HomePage(),
    ),
  );
}

void main() {
  group('Home Page Widget Tests', () {
    testWidgets('Testing no favorites found on startup', (tester) async {
      // setup
      await tester.pumpWidget(createHomeScreen());

      // test
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('Testing if ListView shows up', (tester) async {
      // setup
      await tester.pumpWidget(createHomeScreen());

      // test
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Testing scrolling', (tester) async {
      // setup
      await tester.pumpWidget(createHomeScreen());

      // test
      expect(find.text('Item 0'), findsOneWidget);
      await tester.fling(find.byType(ListView), const Offset(0, -200), 3000);
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsNothing);
    });

    testWidgets('Testing add favorite', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.byIcon(Icons.favorite), findsNothing);

      // simulate favoriting
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // should display add notification
      expect(find.text('Added to favorites'), findsOneWidget);

      // should find a favorite
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });

    testWidgets('Testing remove favorite', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // simulate favoriting
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byIcon(Icons.favorite), findsWidgets);

      // simulate unfavorite
      await tester.tap(find.byIcon(Icons.favorite).first);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // should display remove notification
      expect(find.text('Removed from favorites'), findsOneWidget);

      // should remove favorite
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
  });
}
