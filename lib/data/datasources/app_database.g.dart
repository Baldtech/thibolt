// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WorkoutDao? _workoutDaoInstance;

  WorkoutCategoryDao? _categoryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `workouts` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `categoryId` INTEGER NOT NULL, `duration` INTEGER NOT NULL, `stepsJson` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `name` TEXT NOT NULL, `icon` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WorkoutDao get workoutDao {
    return _workoutDaoInstance ??= _$WorkoutDao(database, changeListener);
  }

  @override
  WorkoutCategoryDao get categoryDao {
    return _categoryDaoInstance ??=
        _$WorkoutCategoryDao(database, changeListener);
  }
}

class _$WorkoutDao extends WorkoutDao {
  _$WorkoutDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutModelInsertionAdapter = InsertionAdapter(
            database,
            'workouts',
            (WorkoutModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'categoryId': item.categoryId,
                  'duration': item.duration,
                  'stepsJson': item.stepsJson
                }),
        _workoutModelDeletionAdapter = DeletionAdapter(
            database,
            'workouts',
            ['id'],
            (WorkoutModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'categoryId': item.categoryId,
                  'duration': item.duration,
                  'stepsJson': item.stepsJson
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutModel> _workoutModelInsertionAdapter;

  final DeletionAdapter<WorkoutModel> _workoutModelDeletionAdapter;

  @override
  Future<List<WorkoutModel>> getWorkouts() async {
    return _queryAdapter.queryList('SELECT * FROM workouts',
        mapper: (Map<String, Object?> row) => WorkoutModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            categoryId: row['categoryId'] as int,
            duration: row['duration'] as int,
            stepsJson: row['stepsJson'] as String));
  }

  @override
  Future<WorkoutModel?> getWorkoutById(int id) async {
    return _queryAdapter.query('SELECT * FROM workouts WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WorkoutModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            categoryId: row['categoryId'] as int,
            duration: row['duration'] as int,
            stepsJson: row['stepsJson'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertWorkout(WorkoutModel workout) async {
    await _workoutModelInsertionAdapter.insert(
        workout, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteWorkout(WorkoutModel workout) async {
    await _workoutModelDeletionAdapter.delete(workout);
  }
}

class _$WorkoutCategoryDao extends WorkoutCategoryDao {
  _$WorkoutCategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _workoutCategoryInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (WorkoutCategory item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'icon': item.icon
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WorkoutCategory> _workoutCategoryInsertionAdapter;

  @override
  Future<List<WorkoutCategory>> getCategories() async {
    return _queryAdapter.queryList('SELECT * FROM categories',
        mapper: (Map<String, Object?> row) => WorkoutCategory(
            id: row['id'] as int,
            name: row['name'] as String,
            icon: row['icon'] as String));
  }

  @override
  Future<WorkoutCategory?> getCategoryById(int id) async {
    return _queryAdapter.query('SELECT * FROM categories WHERE id = ?1',
        mapper: (Map<String, Object?> row) => WorkoutCategory(
            id: row['id'] as int,
            name: row['name'] as String,
            icon: row['icon'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertCategory(WorkoutCategory category) async {
    await _workoutCategoryInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }
}
