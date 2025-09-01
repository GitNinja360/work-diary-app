import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PendingReviewsCard extends StatelessWidget {
  final List<Map<String, dynamic>> pendingReviews;
  final Function(Map<String, dynamic>) onReviewTap;
  final Function(Map<String, dynamic>) onGradeAction;
  final Function(Map<String, dynamic>) onAudioFeedbackAction;
  final Function(Map<String, dynamic>) onReturnForRevisionAction;

  const PendingReviewsCard({
    Key? key,
    required this.pendingReviews,
    required this.onReviewTap,
    required this.onGradeAction,
    required this.onAudioFeedbackAction,
    required this.onReturnForRevisionAction,
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
                  iconName: 'assignment',
                  color: AppTheme.warningLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Pending Reviews",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningLight,
                      ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${pendingReviews.length}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.warningLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            pendingReviews.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Center(
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle_outline',
                            color: AppTheme.successLight,
                            size: 32,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'All caught up!',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            'No pending reviews at the moment',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                    itemCount:
                        pendingReviews.length > 4 ? 4 : pendingReviews.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final review = pendingReviews[index];
                      return Slidable(
                        key: ValueKey(review['id']),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => onGradeAction(review),
                              backgroundColor: AppTheme.successLight,
                              foregroundColor: Colors.white,
                              icon: Icons.grade,
                              label: 'Grade',
                              borderRadius: BorderRadius.circular(8),
                            ),
                            SlidableAction(
                              onPressed: (context) =>
                                  onAudioFeedbackAction(review),
                              backgroundColor: AppTheme.lightTheme.primaryColor,
                              foregroundColor: Colors.white,
                              icon: Icons.mic,
                              label: 'Audio',
                              borderRadius: BorderRadius.circular(8),
                            ),
                            SlidableAction(
                              onPressed: (context) =>
                                  onReturnForRevisionAction(review),
                              backgroundColor: AppTheme.warningLight,
                              foregroundColor: Colors.white,
                              icon: Icons.refresh,
                              label: 'Return',
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => onReviewTap(review),
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
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppTheme
                                      .lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  child: review['studentPhoto'] != null
                                      ? CustomImageWidget(
                                          imageUrl:
                                              review['studentPhoto'] as String,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : CustomIconWidget(
                                          iconName: 'person',
                                          color:
                                              AppTheme.lightTheme.primaryColor,
                                          size: 20,
                                        ),
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review['studentName'] as String,
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
                                      Text(
                                        review['assignmentTitle'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  AppTheme.textSecondaryLight,
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
                                            size: 12,
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            review['submittedAt'] as String,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppTheme
                                                      .textSecondaryLight,
                                                  fontSize: 10.sp,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: _getPriorityColor(
                                                review['priority'] as String)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        review['priority'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: _getPriorityColor(
                                                  review['priority'] as String),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 9.sp,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    CustomIconWidget(
                                      iconName: 'chevron_right',
                                      color: AppTheme.textSecondaryLight,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            if (pendingReviews.length > 4)
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/feedback-and-grades');
                    },
                    child: Text(
                      'View All Reviews (${pendingReviews.length})',
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

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppTheme.errorLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'low':
        return AppTheme.successLight;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
