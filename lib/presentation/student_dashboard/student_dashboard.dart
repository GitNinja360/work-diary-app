import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/course_progress_widget.dart';
import './widgets/greeting_card_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_feedback_widget.dart';
import './widgets/upcoming_assignments_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isConnected = true;
  bool _isRefreshing = false;
  late AnimationController _fabAnimationController;

  // Mock data
  final Map<String, dynamic> studentData = {
    "name": "Sarah Johnson",
    "semester": "Fall 2024",
    "gpa": 3.85,
  };

  final List<Map<String, dynamic>> upcomingAssignments = [
    {
      "id": 1,
      "title": "Research Paper on Machine Learning",
      "course": "Computer Science 301",
      "dueDate": DateTime.now().add(Duration(days: 2)),
      "urgency": "due_soon",
    },
    {
      "id": 2,
      "title": "Calculus Problem Set 5",
      "course": "Mathematics 201",
      "dueDate": DateTime.now().add(Duration(days: 5)),
      "urgency": "upcoming",
    },
    {
      "id": 3,
      "title": "History Essay - World War II",
      "course": "History 150",
      "dueDate": DateTime.now().subtract(Duration(days: 1)),
      "urgency": "overdue",
    },
  ];

  final List<Map<String, dynamic>> recentFeedback = [
    {
      "id": 1,
      "assignment": "Physics Lab Report",
      "teacher": "Dr. Michael Chen",
      "rating": 4,
      "comment":
          "Excellent analysis and clear methodology. Consider expanding on the conclusion section for future reports.",
      "date": DateTime.now().subtract(Duration(days: 3)),
    },
    {
      "id": 2,
      "assignment": "English Literature Essay",
      "teacher": "Prof. Emily Rodriguez",
      "rating": 5,
      "comment":
          "Outstanding work! Your interpretation of the themes was insightful and well-supported with evidence.",
      "date": DateTime.now().subtract(Duration(days: 7)),
    },
  ];

  final List<Map<String, dynamic>> courseProgress = [
    {
      "id": 1,
      "name": "Advanced Programming",
      "instructor": "Dr. James Wilson",
      "progress": 75,
      "nextLesson": "Object-Oriented Design Patterns",
    },
    {
      "id": 2,
      "name": "Data Structures",
      "instructor": "Prof. Lisa Anderson",
      "progress": 60,
      "nextLesson": "Binary Search Trees",
    },
    {
      "id": 3,
      "name": "Digital Marketing",
      "instructor": "Dr. Robert Taylor",
      "progress": 90,
      "nextLesson": "Social Media Analytics",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _checkConnectivity();
    _setupConnectivityListener();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _setupConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dashboard updated successfully'),
        backgroundColor: AppTheme.successLight,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleQuickSubmit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickSubmitSheet(),
    );
  }

  Widget _buildQuickSubmitSheet() {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Submit',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                _buildSubmitOption('Upload File', 'upload_file', () {}),
                SizedBox(height: 1.h),
                _buildSubmitOption('Take Photo', 'camera_alt', () {}),
                SizedBox(height: 1.h),
                _buildSubmitOption('Record Audio', 'mic', () {}),
                SizedBox(height: 1.h),
                _buildSubmitOption('Text Submission', 'edit', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitOption(String title, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'EduFeedback Pro',
              style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _isConnected
                    ? AppTheme.successLight.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _isConnected ? 'wifi' : 'wifi_off',
                    color: _isConnected
                        ? AppTheme.successLight
                        : AppTheme.lightTheme.colorScheme.error,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _isConnected ? 'Online' : 'Offline',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: _isConnected
                          ? AppTheme.successLight
                          : AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              GreetingCardWidget(
                studentName: studentData['name'] as String,
                currentSemester: studentData['semester'] as String,
                gpa: studentData['gpa'] as double,
              ),
              UpcomingAssignmentsWidget(
                assignments: upcomingAssignments,
              ),
              RecentFeedbackWidget(
                feedbackList: recentFeedback,
              ),
              QuickActionsWidget(),
              CourseProgressWidget(
                courses: courseProgress,
              ),
              SizedBox(height: 10.h), // Bottom padding for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleQuickSubmit,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Quick Submit',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              // Already on dashboard
              break;
            case 1:
              Navigator.pushNamed(context, '/course-list');
              break;
            case 2:
              // Navigate to assignments
              break;
            case 3:
              // Navigate to profile
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'school',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
