import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayScheduleCard extends StatelessWidget {
  final List<Map<String, dynamic>> todayClasses;
  final Function(Map<String, dynamic>) onClassTap;

  const TodayScheduleCard({
    Key? key,
    required this.todayClasses,
    required this.onClassTap,
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
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Today's Schedule",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            todayClasses.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Center(
                      child: Text(
                        'No classes scheduled for today',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        todayClasses.length > 3 ? 3 : todayClasses.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final classData = todayClasses[index];
                      return InkWell(
                        onTap: () => onClassTap(classData),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.dividerLight,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                      classData['status'] as String),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      classData['subject'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'access_time',
                                          color: AppTheme.textSecondaryLight,
                                          size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          '${classData['startTime']} - ${classData['endTime']}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppTheme.textSecondaryLight,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'location_on',
                                          color: AppTheme.textSecondaryLight,
                                          size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          classData['room'] as String,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppTheme.textSecondaryLight,
                                              ),
                                        ),
                                        SizedBox(width: 4.w),
                                        CustomIconWidget(
                                          iconName: 'people',
                                          color: AppTheme.textSecondaryLight,
                                          size: 14,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          '${classData['studentCount']} students',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppTheme.textSecondaryLight,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CustomIconWidget(
                                iconName: 'chevron_right',
                                color: AppTheme.textSecondaryLight,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            if (todayClasses.length > 3)
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full schedule
                    },
                    child: Text(
                      'View All Classes (${todayClasses.length})',
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return AppTheme.warningLight;
      case 'ongoing':
        return AppTheme.successLight;
      case 'completed':
        return AppTheme.textSecondaryLight;
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
