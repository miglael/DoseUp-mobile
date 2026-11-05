import 'package:sqflite/sqflite.dart';

class DatabaseSeed {
  DatabaseSeed._();

  static const String patientId = 'patient-001';
  static const String guardianId = 'guardian-001';

  static Future<void> initialize(Database db) async {
    final result = await db.rawQuery('SELECT COUNT(*) AS total FROM patients');

    final count = Sqflite.firstIntValue(result) ?? 0;

    // Jangan memasukkan seed jika database sudah berisi pasien.
    if (count > 0) return;

    await db.transaction((txn) async {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final timestamp = now.toIso8601String();

      // PATIENT
      await txn.insert('patients', {
        'id': patientId,
        'name': 'Siti',
        'age': 68,
        'email': 'siti@example.com',
        'phone': '081234567890',
        'created_at': timestamp,
      });

      // GUARDIAN
      await txn.insert('guardians', {
        'id': guardianId,
        'patient_id': patientId,
        'name': 'Budi',
        'email': 'budi@example.com',
        'phone': '081234567891',
        'relationship': 'Pendamping',
        'created_at': timestamp,
      });

      // MEDICATIONS
      final medications = [
        {
          'id': 'med-001',
          'name': 'Amlodipine',
          'dosage': '5mg',
          'stock': 30,
          'instruction': 'Sesudah Makan',
        },
        {
          'id': 'med-002',
          'name': 'Metformin',
          'dosage': '500mg',
          'stock': 30,
          'instruction': 'Sesudah Makan',
        },
        {
          'id': 'med-003',
          'name': 'Simvastatin',
          'dosage': '20mg',
          'stock': 30,
          'instruction': 'Sesudah Makan',
        },
      ];

      for (final medication in medications) {
        await txn.insert('medications', {
          ...medication,
          'patient_id': patientId,
          'created_at': timestamp,
          'updated_at': timestamp,
        });

        // INITIAL STOCK HISTORY
        await txn.insert('medication_stocks', {
          'id': 'stock-${medication['id']}',
          'medication_id': medication['id'],
          'quantity': medication['stock'],
          'type': 'initial',
          'description': 'Stok awal dari data seed',
          'created_at': timestamp,
        });
      }

      // MEDICATION SCHEDULES
      final schedules = [
        {'id': 'schedule-001', 'medication_id': 'med-001', 'time': '07:00'},
        {'id': 'schedule-002', 'medication_id': 'med-002', 'time': '08:00'},
        {'id': 'schedule-003', 'medication_id': 'med-002', 'time': '20:00'},
        {'id': 'schedule-004', 'medication_id': 'med-003', 'time': '21:00'},
      ];

      for (final schedule in schedules) {
        await txn.insert('medication_schedules', {
          ...schedule,
          'frequency': 'Harian',
          'weekday': null,
          'start_date': today.toIso8601String(),
          'end_date': null,
          'is_active': 1,
        });
      }

      // MEDICATION HISTORIES
      final historyData = [
        {
          'id': 'history-001',
          'schedule_id': 'schedule-001',
          'time': '07:00',
          'status': 'taken',
        },
        {
          'id': 'history-002',
          'schedule_id': 'schedule-002',
          'time': '08:00',
          'status': 'taken',
        },
        {
          'id': 'history-003',
          'schedule_id': 'schedule-003',
          'time': '20:00',
          'status': 'pending',
        },
        {
          'id': 'history-004',
          'schedule_id': 'schedule-004',
          'time': '21:00',
          'status': 'pending',
        },
      ];

      for (final history in historyData) {
        final timeParts = (history['time'] as String).split(':');

        final scheduledAt = DateTime(
          today.year,
          today.month,
          today.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        await txn.insert('medication_histories', {
          'id': history['id'],
          'schedule_id': history['schedule_id'],
          'scheduled_at': scheduledAt.toIso8601String(),
          'taken_at': history['status'] == 'taken'
              ? scheduledAt.toIso8601String()
              : null,
          'status': history['status'],
        });
      }

      // HEALTH LOG
      await txn.insert('health_logs', {
        'id': 'health-001',
        'patient_id': patientId,
        'blood_pressure': '120/80',
        'blood_sugar': 110.0,
        'weight': 60.0,
        'notes': 'Data demonstrasi DoseUp',
        'recorded_at': timestamp,
      });
    });
  }
}
