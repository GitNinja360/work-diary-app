import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SemesterFilterWidget extends StatelessWidget {
  final String selectedSemester;
  final Function(String) onSemesterChanged;

  const SemesterFilterWidget({
    Key? key,
    required this.selectedSemester,
    required this.onSemesterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> semesters = ['Current', 'Past', 'All'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: semesters.map((semester) {
          final bool isSelected = selectedSemester == semester;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSemesterChanged(semester),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    semester,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
