import 'package:flutter/material.dart';
import 'package:shopping_list/models/category.dart';

final categories = {
  Categories.vegetables: const CategoryModel(
    'Vegetables',
    Color.fromARGB(255, 0, 255, 128),
  ),
  Categories.fruit: const CategoryModel(
    'Fruit',
    Color.fromARGB(255, 145, 255, 0),
  ),
  Categories.meat: const CategoryModel(
    'Meat',
    Color.fromARGB(255, 255, 102, 0),
  ),
  Categories.dairy: const CategoryModel(
    'Dairy',
    Color.fromARGB(255, 0, 208, 255),
  ),
  Categories.carbs: const CategoryModel(
    'Carbs',
    Color.fromARGB(255, 0, 60, 255),
  ),
  Categories.sweets: const CategoryModel(
    'Sweets',
    Color.fromARGB(255, 255, 149, 0),
  ),
  Categories.spices: const CategoryModel(
    'Spices',
    Color.fromARGB(255, 255, 187, 0),
  ),
  Categories.convenience: const CategoryModel(
    'Convenience',
    Color.fromARGB(255, 191, 0, 255),
  ),
  Categories.hygiene: const CategoryModel(
    'Hygiene',
    Color.fromARGB(255, 149, 0, 255),
  ),
  Categories.other: const CategoryModel(
    'Other',
    Color.fromARGB(255, 0, 225, 255),
  ),
};
