import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/category_item.dart';
import 'package:meals/widgets/meal_item.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;

  FavoriteScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: favoriteMeals.length == 0
          ? Text('You have no favorites yet - start adding some!')
          : Column(
              children: favoriteMeals
                  .map(
                    (e) => MealItem(
                        id: e.id,
                        title: e.title,
                        imageUrl: e.imageUrl,
                        duration: e.duration,
                        complexity: e.complexity,
                        affordability: e.affordability),
                  )
                  .toList(),
            ),
    );
  }
}
