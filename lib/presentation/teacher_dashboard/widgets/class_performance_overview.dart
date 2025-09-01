import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassPerformanceOverview extends StatelessWidget {
  final List<Map<String, dynamic>> classPerformance;
  final Function(Map<String, dynamic>) onClassTap;

  const ClassPerformanceOverview({
    Key? key,
    required this.classPerformance,
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
                  iconName: 'trending_up',
                  color: AppTheme.successLight,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  "Class Performance",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successLight,
                      ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            classPerformance.isEmpty
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: Center(
                      child: Text(
                        'No performance data available',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: classPerformance.length > 3
                        ? 3
                        : classPerformance.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final classData = classPerformance[index];
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      classData['className'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      color: _getGradeColor(
                                              classData['averageGrade']
                                                  as double)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${(classData['averageGrade'] as double).toStringAsFixed(1)}%',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: _getGradeColor(
                                                classData['averageGrade']
                                                    as double),
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMetricItem(
                                      context,
                                      'Students',
                                      '${classData['totalStudents']}',
                                      Icons.people,
                                      AppTheme.lightTheme.primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildMetricItem(
                                      context,
                                      'Engagement',
                                      '${(classData['engagementRate'] as double).toStringAsFixed(0)}%',
                                      Icons.favorite,
                                      AppTheme.accentLight,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildMetricItem(
                                      context,
                                      'Attendance',
                                      '${(classData['attendanceRate'] as double).toStringAsFixed(0)}%',
                                      Icons.check_circle,
                                      AppTheme.successLight,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Container(
                                height: 8.h,
                                child: Semantics(
                                  label:
                                      "Performance trend chart for ${classData['className']}",
                                  child: LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData:
                                          const FlTitlesData(show: false),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _generateSpots(
                                              classData['performanceTrend']
                                                  as List),
                                          isCurved: true,
                                          color:
                                              AppTheme.lightTheme.primaryColor,
                                          barWidth: 2,
                                          dotData: const FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: AppTheme
                                                .lightTheme.primaryColor
                                                .withValues(alpha: 0.1),
                                          ),
                                        ),
                                      ],
                                      minX: 0,
                                      maxX: 6,
                                      minY: 0,
                                      maxY: 100,
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
            if (classPerformance.length > 3)
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full analytics
                    },
                    child: Text(
                      'View Detailed Analytics',
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

  Widget _buildMetricItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon.toString().split('.').last,
          color: color,
          size: 16,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
                fontSize: 9.sp,
              ),
        ),
      ],
    );
  }

  List<FlSpot> _generateSpots(List performanceTrend) {
    return performanceTrend.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), (entry.value as num).toDouble());
    }).toList();
  }

  Color _getGradeColor(double grade) {
    if (grade >= 90) return AppTheme.successLight;
    if (grade >= 80) return AppTheme.accentLight;
    if (grade >= 70) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }
}
