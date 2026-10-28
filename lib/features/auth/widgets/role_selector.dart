import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../core/theme/app_theme.dart';

class RoleSelector extends StatelessWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole> onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RoleCard(
            title: 'Saya Pasien',
            icon: Icons.person_outline,
            isSelected: selectedRole == UserRole.patient,
            onTap: () => onChanged(UserRole.patient),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _RoleCard(
            title: 'Saya Pendamping',
            icon: Icons.people_outline,
            isSelected: selectedRole == UserRole.guardian,
            onTap: () => onChanged(UserRole.guardian),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: const BoxConstraints(minHeight: 96),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryLight
                  : const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? AppTheme.primary : AppTheme.border,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
