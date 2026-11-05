import 'package:sqflite/sqflite.dart';

import '../../core/database/app_database.dart';
import '../../models/medication_schedule_view_model.dart';

class MedicationRepository {
  final AppDatabase _appDatabase;

  MedicationRepository({AppDatabase? appDatabase})
    : _appDatabase = appDatabase ?? AppDatabase.instance;

  Future<Database> get _db async => _appDatabase.database;

  static const String _patientId = 'patient-001';

  String _dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  DateTime _scheduledDate(DateTime date, String time) {
    final parts = time.split(':');

    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  String _generateId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }

  // ============================================================
  // GET DAILY SCHEDULES
  // ============================================================

  Future<List<MedicationScheduleViewModel>> getSchedulesForDate(
    DateTime date,
  ) async {
    final db = await _db;
    final dateKey = _dateKey(date);

    return db.transaction((txn) async {
      final schedules = await txn.rawQuery(
        '''
        SELECT
          s.id,
          s.medication_id,
          s.frequency,
          s.time,
          s.weekday,
          s.start_date,
          s.end_date,
          m.name,
          m.dosage,
          m.stock,
          m.instruction
        FROM medication_schedules s
        INNER JOIN medications m
          ON m.id = s.medication_id
        WHERE m.patient_id = ?
          AND s.is_active = 1
          AND substr(s.start_date, 1, 10) <= ?
          AND (
            s.end_date IS NULL
            OR substr(s.end_date, 1, 10) >= ?
          )
      ''',
        [_patientId, dateKey, dateKey],
      );

      final applicableSchedules = schedules.where((schedule) {
        final frequency = schedule['frequency'] as String;
        final weekday = schedule['weekday'] as int?;

        if (frequency == 'Harian') return true;

        return weekday == date.weekday;
      }).toList();

      // Pastikan setiap jadwal memiliki riwayat untuk tanggal ini.
      for (final schedule in applicableSchedules) {
        final scheduleId = schedule['id'] as String;
        final scheduledAt = _scheduledDate(date, schedule['time'] as String);

        final existingHistory = await txn.query(
          'medication_histories',
          where: 'schedule_id = ? AND substr(scheduled_at, 1, 10) = ?',
          whereArgs: [scheduleId, dateKey],
          limit: 1,
        );

        if (existingHistory.isEmpty) {
          await txn.insert('medication_histories', {
            'id': _generateId('history'),
            'schedule_id': scheduleId,
            'scheduled_at': scheduledAt.toIso8601String(),
            'taken_at': null,
            'status': 'pending',
            'snoozed_until': null,
          });
        }
      }

      final rows = await txn.rawQuery(
        '''
        SELECT
          s.id AS schedule_id,
          s.medication_id,
          s.frequency,
          s.time,
          s.weekday,
          s.start_date,
          s.end_date,
          m.name,
          m.dosage,
          m.stock,
          m.instruction,
          h.status,
          h.snoozed_until,
          h.scheduled_at
        FROM medication_schedules s
        INNER JOIN medications m
          ON m.id = s.medication_id
        INNER JOIN medication_histories h
          ON h.schedule_id = s.id
        WHERE m.patient_id = ?
          AND s.is_active = 1
          AND substr(h.scheduled_at, 1, 10) = ?
        ORDER BY h.scheduled_at ASC
      ''',
        [_patientId, dateKey],
      );

      return _mapToViewModels(rows);
    });
  }

  List<MedicationScheduleViewModel> _mapToViewModels(
    List<Map<String, Object?>> rows,
  ) {
    final now = DateTime.now();

    final pendingRows = rows.where((row) {
      return row['status'] != 'taken';
    }).toList();

    // Jadwal pending paling awal menjadi jadwal berikutnya.
    final nextPendingId = pendingRows.isEmpty
        ? null
        : pendingRows.first['schedule_id'] as String;

    return rows.map((row) {
      final storedStatus = row['status'] as String;
      final snoozedUntil = row['snoozed_until'] == null
          ? null
          : DateTime.parse(row['snoozed_until'] as String);

      MedicationStatus status;

      if (storedStatus == 'taken') {
        status = MedicationStatus.completed;
      } else if (storedStatus == 'snoozed' &&
          snoozedUntil != null &&
          snoozedUntil.isAfter(now)) {
        status = MedicationStatus.snoozed;
      } else if (row['schedule_id'] == nextPendingId) {
        status = MedicationStatus.current;
      } else {
        status = MedicationStatus.upcoming;
      }

      return MedicationScheduleViewModel(
        scheduleId: row['schedule_id'] as String,
        medicationId: row['medication_id'] as String,
        name: row['name'] as String,
        dosage: row['dosage'] as String,
        stock: row['stock'] as int,
        instruction: row['instruction'] as String,
        time: row['time'] as String,
        frequency: row['frequency'] as String,
        weekday: row['weekday'] as int?,
        startDate: DateTime.parse(row['start_date'] as String),
        endDate: row['end_date'] == null
            ? null
            : DateTime.parse(row['end_date'] as String),
        status: status,
      );
    }).toList();
  }

  // ============================================================
  // ADD MEDICATION
  // ============================================================

  Future<void> addMedication({
    required String name,
    required String dosage,
    required int stock,
    required String time,
    required String frequency,
    required DateTime startDate,
    DateTime? endDate,
    required String instruction,
    List<int> selectedWeekdays = const [],
  }) async {
    final db = await _db;
    final now = DateTime.now();

    final medicationId = _generateId('med');
    final timestamp = now.toIso8601String();

    await db.transaction((txn) async {
      await txn.insert('medications', {
        'id': medicationId,
        'patient_id': _patientId,
        'name': name,
        'dosage': dosage,
        'stock': stock,
        'instruction': instruction,
        'created_at': timestamp,
        'updated_at': timestamp,
      });

      await txn.insert('medication_stocks', {
        'id': _generateId('stock'),
        'medication_id': medicationId,
        'quantity': stock,
        'type': 'initial',
        'description': 'Stok awal obat',
        'created_at': timestamp,
      });

      final weekdays = frequency == 'Harian'
          ? <int?>[null]
          : selectedWeekdays.map<int?>((day) => day).toList();

      if (weekdays.isEmpty) {
        throw ArgumentError('Pilih minimal satu hari untuk jadwal mingguan.');
      }

      for (final weekday in weekdays) {
        await txn.insert('medication_schedules', {
          'id': _generateId('schedule'),
          'medication_id': medicationId,
          'frequency': frequency,
          'time': time,
          'weekday': weekday,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
          'is_active': 1,
        });
      }
    });
  }

  // ============================================================
  // MARK AS TAKEN
  // ============================================================

  Future<void> markAsTaken({
    required String scheduleId,
    required DateTime date,
  }) async {
    final db = await _db;
    final dateKey = _dateKey(date);
    final now = DateTime.now();

    final histories = await db.query(
      'medication_histories',
      where: 'schedule_id = ? AND substr(scheduled_at, 1, 10) = ?',
      whereArgs: [scheduleId, dateKey],
      limit: 1,
    );

    if (histories.isEmpty) return;

    await db.update(
      'medication_histories',
      {
        'status': 'taken',
        'taken_at': now.toIso8601String(),
        'snoozed_until': null,
      },
      where: 'id = ?',
      whereArgs: [histories.first['id']],
    );
  }

  // ============================================================
  // SNOOZE
  // ============================================================

  Future<void> snooze({
    required String scheduleId,
    required DateTime date,
    Duration duration = const Duration(minutes: 10),
  }) async {
    final db = await _db;
    final dateKey = _dateKey(date);

    final histories = await db.query(
      'medication_histories',
      where: 'schedule_id = ? AND substr(scheduled_at, 1, 10) = ?',
      whereArgs: [scheduleId, dateKey],
      limit: 1,
    );

    if (histories.isEmpty) return;

    final history = histories.first;

    if (history['status'] == 'taken') return;

    await db.update(
      'medication_histories',
      {
        'status': 'snoozed',
        'snoozed_until': DateTime.now().add(duration).toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [history['id']],
    );
  }
}
