import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SemesterSelectorWidget extends StatelessWidget {
  final String selectedSemester;
  final List<String> semesters;
  final Function(String) onSemesterChanged;

  const SemesterSelectorWidget({
    Key? key,
    required this.selectedSemester,
    required this.semesters,
    required this.onSemesterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSemester,
          icon: CustomIconWidget(
            iconName: 'keyboard_arrow_down',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
          items: semesters.map((String semester) {
            return DropdownMenuItem<String>(
              value: semester,
              child: Text(
                semester,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onSemesterChanged(newValue);
            }
          },
        ),
      ),
    );
  }
}
