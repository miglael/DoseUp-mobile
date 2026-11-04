import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class DaySelector extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onChanged;

  const DaySelector({
    super.key,
    required this.selectedDay,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> days = [
    {'label': 'Sen', 'value': 1},
    {'label': 'Sel', 'value': 2},
    {'label': 'Rab', 'value': 3},
    {'label': 'Kam', 'value': 4},
    {'label': 'Jum', 'value': 5},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days.map((day) {
        final dayValue = day['value'] as int;
        final isSelected = selectedDay == dayValue;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () => onChanged(dayValue),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 82,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? AppTheme.primary : AppTheme.border,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  day['label'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
