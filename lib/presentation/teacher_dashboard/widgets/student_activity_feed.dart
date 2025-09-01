import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StudentActivityFeed extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  final Function(Map<String, dynamic>) onActivityTap;
  final Function(Map<String, dynamic>) onQuickResponse;

  const StudentActivityFeed({
    Key? key,
    required this.activities,
    required this.onActivityTap,
    required this.onQuickResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'timeline',
                  color: AppTheme.secondaryLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Recent Activity",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryLight,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            activities.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Center(
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'hourglass_empty',
                            color: AppTheme.textSecondaryLight,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'No recent activity',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondaryLight,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length > 5 ? 5 : activities.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 2.h,
                      color: AppTheme.dividerLight,
                    ),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return InkWell(
                        onTap: () => onActivityTap(activity),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: _getActivityColor(
                                        activity['type'] as String)
                                    .withValues(alpha: 0.1),
                                child: CustomIconWidget(
                                  iconName: _getActivityIcon(
                                      activity['type'] as String),
                                  color: _getActivityColor(
                                      activity['type'] as String),
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme.textPrimaryLight,
                                            ),
                                        children: [
                                          TextSpan(
                                            text: activity['studentName']
                                                as String,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextSpan(
                                            text: ' ${activity['action']}',
                                          ),
                                          TextSpan(
                                            text: ' ${activity['target']}',
                                            style: TextStyle(
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Text(
                                      activity['timestamp'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppTheme.textSecondaryLight,
                                            fontSize: 10.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              if (activity['requiresResponse'] == true)
                                Container(
                                  margin: EdgeInsets.only(left: 2.w),
                                  child: InkWell(
                                    onTap: () => onQuickResponse(activity),
                                    borderRadius: BorderRadius.circular(16),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 1.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppTheme
                                              .lightTheme.primaryColor
                                              .withValues(alpha: 0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'Respond',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            if (activities.length > 5)
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full activity feed
                    },
                    child: Text(
                      'View All Activity',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'submission':
        return 'assignment_turned_in';
      case 'discussion':
        return 'forum';
      case 'quiz':
        return 'quiz';
      case 'question':
        return 'help_outline';
      case 'comment':
        return 'comment';
      default:
        return 'notifications';
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'submission':
        return AppTheme.successLight;
      case 'discussion':
        return AppTheme.lightTheme.primaryColor;
      case 'quiz':
        return AppTheme.warningLight;
      case 'question':
        return AppTheme.accentLight;
      case 'comment':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
