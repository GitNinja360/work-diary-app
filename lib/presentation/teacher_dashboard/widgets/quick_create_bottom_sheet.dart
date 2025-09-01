import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickCreateBottomSheet extends StatelessWidget {
  final Function() onCreateQuiz;
  final Function() onCreateAssignment;
  final Function() onCreatePoll;
  final Function() onCreateDiscussion;

  const QuickCreateBottomSheet({
    Key? key,
    required this.onCreateQuiz,
    required this.onCreateAssignment,
    required this.onCreatePoll,
    required this.onCreateDiscussion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.dividerLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Quick Create',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildCreateOption(
                  context: context,
                  icon: 'quiz',
                  title: 'Quiz',
                  subtitle: 'Quick assessment',
                  color: AppTheme.warningLight,
                  onTap: () {
                    Navigator.pop(context);
                    onCreateQuiz();
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildCreateOption(
                  context: context,
                  icon: 'assignment',
                  title: 'Assignment',
                  subtitle: 'Detailed task',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: () {
                    Navigator.pop(context);
                    onCreateAssignment();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildCreateOption(
                  context: context,
                  icon: 'poll',
                  title: 'Poll',
                  subtitle: 'Get opinions',
                  color: AppTheme.accentLight,
                  onTap: () {
                    Navigator.pop(context);
                    onCreatePoll();
                  },
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildCreateOption(
                  context: context,
                  icon: 'forum',
                  title: 'Discussion',
                  subtitle: 'Start conversation',
                  color: AppTheme.secondaryLight,
                  onTap: () {
                    Navigator.pop(context);
                    onCreateDiscussion();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildCreateOption({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
