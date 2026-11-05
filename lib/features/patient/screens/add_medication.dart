import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/medication_provider.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<int> _selectedWeekdays = [];

  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _stockController = TextEditingController();

  String _frequency = 'Harian';
  String _instruction = 'Sesudah Makan';

  TimeOfDay? _selectedTime;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate;

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 8, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _selectDate({required bool isStart}) async {
    final now = DateTime.now();

    final initialDate = isStart
        ? _startDate ?? now
        : _endDate ?? _startDate ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStart ? DateTime(now.year - 5) : _startDate ?? now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    setState(() {
      if (isStart) {
        _startDate = date;

        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = null;
        }
      } else {
        _endDate = date;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$month/$day/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedTime == null) {
      _showError('Silakan pilih waktu konsumsi obat.');
      return;
    }

    if (_startDate == null) {
      _showError('Silakan pilih tanggal mulai.');
      return;
    }

    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      _showError('Tanggal selesai tidak boleh sebelum tanggal mulai.');
      return;
    }

    if (_frequency == 'Mingguan' && _selectedWeekdays.isEmpty) {
      _showError('Silakan pilih minimal satu hari konsumsi.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await context.read<MedicationProvider>().addMedication(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        time: _formatTime(_selectedTime),
        frequency: _frequency,
        startDate: _startDate!,
        endDate: _endDate,
        instruction: _instruction,
        selectedWeekdays: _frequency == 'Mingguan'
            ? List<int>.from(_selectedWeekdays)
            : [],
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      _showError('Gagal menyimpan obat. Silakan coba kembali.');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FE),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FE),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppTheme.textPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tambah Obat Baru',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE5EAF2)),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            children: [
              _buildBasicInformation(),
              const SizedBox(height: 24),
              _buildScheduleInformation(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5EAF2))),
          ),
          child: SizedBox(
            height: 64,
            child: FilledButton(
              onPressed: _isSaving ? null : _saveMedication,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInformation() {
    return _buildSectionCard(
      icon: Icons.medication,
      title: 'Informasi Dasar',
      children: [
        _buildTextField(
          label: 'Nama Obat',
          controller: _nameController,
          hint: 'Contoh: Paracetamol 500mg',
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Dosis',
                controller: _dosageController,
                hint: 'Contoh: 1 Tablet',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Stok (Jumlah)',
                controller: _stockController,
                hint: 'Contoh: 30',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleInformation() {
    return _buildSectionCard(
      icon: Icons.access_time_filled,
      title: 'Jadwal Konsumsi',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDropdown()),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPickerField(
                label: 'Waktu',
                value: _formatTime(_selectedTime),
                isPlaceholder: _selectedTime == null,
                onTap: _selectTime,
              ),
            ),
          ],
        ),
        if (_frequency == 'Mingguan') ...[
          const SizedBox(height: 20),
          _buildWeekdaySelector(),
        ],

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildPickerField(
                label: 'Tanggal Mulai',
                value: _formatDate(_startDate),
                onTap: () => _selectDate(isStart: true),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPickerField(
                label: 'Tanggal Selesai (Opsional)',
                value: _formatDate(_endDate),
                isPlaceholder: _endDate == null,
                onTap: () => _selectDate(isStart: false),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Keterangan Makan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(child: _buildMealOption('Sebelum Makan')),
            const SizedBox(width: 12),
            Expanded(child: _buildMealOption('Sesudah Makan')),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5EAF2), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Wajib diisi';
            }

            if (label == 'Stok (Jumlah)' && (int.tryParse(value) ?? 0) <= 0) {
              return 'Stok harus lebih dari 0';
            }

            return null;
          },
          decoration: _inputDecoration(hint),
          style: const TextStyle(fontSize: 19, color: AppTheme.textPrimary),
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frekuensi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: _frequency,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          decoration: _inputDecoration('Pilih frekuensi').copyWith(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
          ),
          style: const TextStyle(fontSize: 17, color: AppTheme.textPrimary),
          items: const [
            DropdownMenuItem(
              value: 'Harian',
              child: Text(
                'Harian',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            DropdownMenuItem(
              value: 'Mingguan',
              child: Text(
                'Mingguan',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _frequency = value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildWeekdaySelector() {
    const weekdays = [
      {'label': 'Sen', 'value': 1},
      {'label': 'Sel', 'value': 2},
      {'label': 'Rab', 'value': 3},
      {'label': 'Kam', 'value': 4},
      {'label': 'Jum', 'value': 5},
      {'label': 'Sab', 'value': 6},
      {'label': 'Min', 'value': 7},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pilih Hari Konsumsi',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: weekdays.map((day) {
            final value = day['value'] as int;
            final selected = _selectedWeekdays.contains(value);

            return FilterChip(
              label: Text(day['label'] as String),
              selected: selected,
              selectedColor: const Color(0xFFE5F2F0),
              checkmarkColor: AppTheme.primary,
              labelStyle: TextStyle(
                color: selected ? AppTheme.primary : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide(
                color: selected ? AppTheme.primary : AppTheme.border,
              ),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedWeekdays.add(value);
                  } else {
                    _selectedWeekdays.remove(value);
                  }
                });
              },
            );
          }).toList(),
        ),
        if (_selectedWeekdays.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Pilih minimal satu hari.',
              style: TextStyle(fontSize: 13, color: Colors.red.shade700),
            ),
          ),
      ],
    );
  }

  Widget _buildPickerField({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isPlaceholder = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border, width: 1.4),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  color: isPlaceholder ? Colors.grey : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealOption(String value) {
    final selected = _instruction == value;

    return InkWell(
      onTap: () {
        setState(() => _instruction = value);
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE5F2F0) : const Color(0xFFF7F8FE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.border,
            width: selected ? 2 : 1.4,
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: selected ? AppTheme.primary : AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF7F8FE),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppTheme.border, width: 1.4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppTheme.border, width: 1.4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppTheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
