import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home, 'Beranda'),
    (Icons.medication_outlined, 'Jadwal'),
    (Icons.history, 'Riwayat'),
    (Icons.person_outline, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD7E0DE)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: List.generate(
              _items.length,
              (index) => _buildNavItem(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final selected = selectedIndex == index;
    final item = _items[index];

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () => onTap(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDCEAE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.$1, color: AppTheme.textSecondary, size: 25),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  item.$2,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
