import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtons extends StatelessWidget {
  final Function() onCreateAssignment;
  final Function() onRecordFeedback;
  final Function() onStartPoll;
  final Function() onViewAnalytics;

  const QuickActionButtons({
    Key? key,
    required this.onCreateAssignment,
    required this.onRecordFeedback,
    required this.onStartPoll,
    required this.onViewAnalytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: 'assignment_add',
                  label: 'Create\nAssignment',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: onCreateAssignment,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: 'mic',
                  label: 'Record\nFeedback',
                  color: AppTheme.secondaryLight,
                  onTap: onRecordFeedback,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: 'poll',
                  label: 'Start\nPoll',
                  color: AppTheme.accentLight,
                  onTap: onStartPoll,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionButton(
                  context: context,
                  icon: 'analytics',
                  label: 'View\nAnalytics',
                  color: AppTheme.successLight,
                  onTap: onViewAnalytics,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
