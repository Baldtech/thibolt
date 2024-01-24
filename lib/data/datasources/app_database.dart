import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../domain/entities/category.dart';
import '../models/workout.dart';
import 'dao/category_dao.dart';
import 'dao/workout_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [WorkoutModel, WorkoutCategory])
abstract class AppDatabase extends FloorDatabase {
  WorkoutDao get workoutDao;
  WorkoutCategoryDao get categoryDao;
}
