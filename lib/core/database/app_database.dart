import 'package:doseup_project/data/seed/medication_seed.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static Database? _database;

  static const String _databaseName = 'doseup.db';
  static const int _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await DatabaseSeed.initialize(db);
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        age INTEGER,
        email TEXT,
        phone TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE guardians (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        relationship TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (patient_id)
          REFERENCES patients(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        instruction TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (patient_id)
          REFERENCES patients(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE medication_schedules (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        frequency TEXT NOT NULL,
        time TEXT NOT NULL,
        weekday INTEGER,
        start_date TEXT NOT NULL,
        end_date TEXT,
        is_active INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (medication_id)
          REFERENCES medications(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE medication_histories (
        id TEXT PRIMARY KEY,
        schedule_id TEXT NOT NULL,
        scheduled_at TEXT NOT NULL,
        taken_at TEXT,
        status TEXT NOT NULL,
        snoozed_until TEXT,
        FOREIGN KEY (schedule_id)
          REFERENCES medication_schedules(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE medication_stocks (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (medication_id)
          REFERENCES medications(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE health_logs (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        blood_pressure TEXT,
        blood_sugar REAL,
        weight REAL,
        notes TEXT,
        recorded_at TEXT NOT NULL,
        FOREIGN KEY (patient_id)
          REFERENCES patients(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_medications_patient
      ON medications(patient_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_schedules_medication
      ON medication_schedules(medication_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_histories_schedule
      ON medication_histories(schedule_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE medication_histories
        ADD COLUMN snoozed_until TEXT
      ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
