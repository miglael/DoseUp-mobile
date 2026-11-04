import '../../models/medication_schedule_model.dart';

class MedicationSeed {
  MedicationSeed._();

  static List<MedicationScheduleModel> createSchedules() {
    return [
      MedicationScheduleModel(
        id: 'med-001',
        name: 'Amlodipine',
        dosage: '5mg',
        time: '07:00',
        instruction: 'Sesudah makan',
        weekday: 3,
        status: MedicationStatus.completed,
      ),
      MedicationScheduleModel(
        id: 'med-002',
        name: 'Metformin',
        dosage: '500mg',
        time: '08:00',
        instruction: 'Sesudah makan',
        weekday: 3,
        status: MedicationStatus.completed,
      ),
      MedicationScheduleModel(
        id: 'med-003',
        name: 'Metformin',
        dosage: '500mg',
        time: '20:00',
        instruction: 'Sesudah makan',
        weekday: 3,
        status: MedicationStatus.upcoming,
      ),
      MedicationScheduleModel(
        id: 'med-004',
        name: 'Simvastatin',
        dosage: '20mg',
        time: '21:00',
        instruction: 'Sesudah makan',
        weekday: 3,
        status: MedicationStatus.upcoming,
      ),
    ];
  }
}
