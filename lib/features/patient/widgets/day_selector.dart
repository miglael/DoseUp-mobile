import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class DaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  const DaySelector({
    super.key,
    required this.selectedDate,
    required this.onChanged,
  });

  DateTime _getWeekStart(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final weekStart = _getWeekStart(selectedDate);

    final dates = List.generate(
      7,
      (index) => weekStart.add(Duration(days: index)),
    );

    return Row(
      children: dates.map((date) {
        final isSelected =
            date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        const labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => onChanged(date),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 82,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      labels[date.weekday - 1],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
