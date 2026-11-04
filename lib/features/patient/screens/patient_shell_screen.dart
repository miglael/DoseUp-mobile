import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_navbar.dart';
import 'patient_dashboard_screen.dart';
import 'medication_schedule_screen.dart';
import 'medication_history_screen.dart';
import 'patient_profile_screen.dart';

class PatientShellScreen extends StatefulWidget {
  const PatientShellScreen({super.key});

  @override
  State<PatientShellScreen> createState() => _PatientShellScreenState();
}

class _PatientShellScreenState extends State<PatientShellScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = [
    const PatientDashboardScreen(),
    const MedicationScheduleScreen(),
    const MedicationHistoryScreen(),
    const PatientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: AppBottomNavbar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
