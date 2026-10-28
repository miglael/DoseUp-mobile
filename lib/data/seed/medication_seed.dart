import '../../models/medication_schedule_model.dart';

class MedicationSeed {
  MedicationSeed._();

  static List<MedicationScheduleModel> createSchedules() {
    return [
      MedicationScheduleModel(
        id: 'med-001',
        name: 'Amlodipine',
        dosage: '5mg',
        time: '07:00 Pagi',
        instruction: '',
        status: MedicationStatus.completed,
      ),
      MedicationScheduleModel(
        id: 'med-002',
        name: 'Metformin',
        dosage: '500mg',
        time: '08:00 Pagi',
        instruction:
            'Diminum sesudah makan. Jangan lupa minum segelas air putih penuh.',
        status: MedicationStatus.current,
      ),
      MedicationScheduleModel(
        id: 'med-003',
        name: 'Simvastatin',
        dosage: '20mg',
        time: '20:00 Malam',
        instruction: '',
        status: MedicationStatus.upcoming,
      ),
    ];
  }
}
