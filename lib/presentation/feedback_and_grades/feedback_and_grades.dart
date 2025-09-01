import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/course_grade_card_widget.dart';
import './widgets/feedback_detail_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/gpa_display_widget.dart';
import './widgets/grade_trends_chart_widget.dart';
import './widgets/segmented_control_widget.dart';
import './widgets/semester_selector_widget.dart';

class FeedbackAndGrades extends StatefulWidget {
  const FeedbackAndGrades({Key? key}) : super(key: key);

  @override
  State<FeedbackAndGrades> createState() => _FeedbackAndGradesState();
}

class _FeedbackAndGradesState extends State<FeedbackAndGrades> {
  String _selectedSemester = 'Fall 2024';
  int _selectedSegment = 0;
  String _selectedSortBy = 'Date';
  String _selectedCourse = 'All Courses';
  DateTimeRange? _selectedDateRange;
  bool _isRefreshing = false;

  final List<String> _semesters = [
    'Fall 2024',
    'Spring 2024',
    'Fall 2023',
    'Spring 2023',
  ];

  final List<String> _segments = [
    'All Courses',
    'Recent Feedback',
    'Grade Trends',
  ];

  // Mock data for courses and grades
  final List<Map<String, dynamic>> _coursesData = [
    {
      "id": 1,
      "courseName": "Advanced Data Structures",
      "courseCode": "CS 401",
      "currentGrade": 92.5,
      "letterGrade": "A",
      "instructorName": "Dr. Sarah Johnson",
      "instructorImage":
          "https://images.pexels.com/photos/3769021/pexels-photo-3769021.jpeg?auto=compress&cs=tinysrgb&w=400",
      "feedbackCount": 3,
      "assignments": [
        {
          "name": "Binary Tree Implementation",
          "score": 95.0,
          "maxScore": 100.0,
          "submissionDate": "08/25/2024"
        },
        {
          "name": "Graph Algorithms Project",
          "score": 88.0,
          "maxScore": 100.0,
          "submissionDate": "08/20/2024"
        },
        {
          "name": "Hash Table Analysis",
          "score": 94.0,
          "maxScore": 100.0,
          "submissionDate": "08/15/2024"
        }
      ]
    },
    {
      "id": 2,
      "courseName": "Machine Learning Fundamentals",
      "courseCode": "CS 450",
      "currentGrade": 87.3,
      "letterGrade": "B+",
      "instructorName": "Prof. Michael Chen",
      "instructorImage":
          "https://images.pexels.com/photos/2182970/pexels-photo-2182970.jpeg?auto=compress&cs=tinysrgb&w=400",
      "feedbackCount": 1,
      "assignments": [
        {
          "name": "Linear Regression Model",
          "score": 85.0,
          "maxScore": 100.0,
          "submissionDate": "08/28/2024"
        },
        {
          "name": "Neural Network Implementation",
          "score": 90.0,
          "maxScore": 100.0,
          "submissionDate": "08/22/2024"
        }
      ]
    },
    {
      "id": 3,
      "courseName": "Software Engineering Principles",
      "courseCode": "CS 420",
      "currentGrade": 94.8,
      "letterGrade": "A",
      "instructorName": "Dr. Emily Rodriguez",
      "instructorImage":
          "https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "feedbackCount": 2,
      "assignments": [
        {
          "name": "Agile Development Project",
          "score": 96.0,
          "maxScore": 100.0,
          "submissionDate": "08/30/2024"
        },
        {
          "name": "Code Review Assignment",
          "score": 92.0,
          "maxScore": 100.0,
          "submissionDate": "08/24/2024"
        }
      ]
    }
  ];

  // Mock data for recent feedback
  final List<Map<String, dynamic>> _recentFeedback = [
    {
      "id": 1,
      "instructorName": "Dr. Sarah Johnson",
      "instructorImage":
          "https://images.pexels.com/photos/3769021/pexels-photo-3769021.jpeg?auto=compress&cs=tinysrgb&w=400",
      "assignmentName": "Binary Tree Implementation",
      "date": "08/25/2024",
      "textFeedback":
          "Excellent implementation of the binary tree data structure. Your code is well-organized and demonstrates a strong understanding of tree traversal algorithms. The recursive approach you used for insertion and deletion is particularly elegant.",
      "hasAudioFeedback": true,
      "rubricScores": [
        {"category": "Code Quality", "score": 18, "maxScore": 20},
        {"category": "Algorithm Efficiency", "score": 19, "maxScore": 20},
        {"category": "Documentation", "score": 17, "maxScore": 20},
        {"category": "Testing", "score": 16, "maxScore": 20}
      ]
    },
    {
      "id": 2,
      "instructorName": "Prof. Michael Chen",
      "instructorImage":
          "https://images.pexels.com/photos/2182970/pexels-photo-2182970.jpeg?auto=compress&cs=tinysrgb&w=400",
      "assignmentName": "Linear Regression Model",
      "date": "08/28/2024",
      "textFeedback":
          "Good work on implementing the linear regression model. Your understanding of the mathematical concepts is evident. However, consider optimizing your gradient descent algorithm for better performance with larger datasets.",
      "hasAudioFeedback": false,
      "rubricScores": [
        {"category": "Mathematical Understanding", "score": 17, "maxScore": 20},
        {"category": "Implementation", "score": 16, "maxScore": 20},
        {"category": "Data Visualization", "score": 18, "maxScore": 20}
      ]
    }
  ];

  // Mock data for grade trends
  final List<Map<String, dynamic>> _gradeTrendsData = [
    {"month": "Jan", "grade": 85.0},
    {"month": "Feb", "grade": 87.5},
    {"month": "Mar", "grade": 89.2},
    {"month": "Apr", "grade": 91.0},
    {"month": "May", "grade": 88.5},
    {"month": "Jun", "grade": 90.3},
    {"month": "Jul", "grade": 92.1},
    {"month": "Aug", "grade": 93.5},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Feedback & Grades'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            _buildHeader(),
            _buildSegmentedControl(),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedSegment == 1
          ? FloatingActionButton.extended(
              onPressed: _requestFeedback,
              icon: CustomIconWidget(
                iconName: 'feedback',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 20,
              ),
              label: Text('Request Feedback'),
            )
          : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SemesterSelectorWidget(
                  selectedSemester: _selectedSemester,
                  semesters: _semesters,
                  onSemesterChanged: (semester) {
                    setState(() {
                      _selectedSemester = semester;
                    });
                  },
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: GpaDisplayWidget(
                  gpa: 3.67,
                  isIncreasing: true,
                  previousGpa: 3.52,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SegmentedControlWidget(
        selectedIndex: _selectedSegment,
        segments: _segments,
        onSegmentChanged: (index) {
          setState(() {
            _selectedSegment = index;
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedSegment) {
      case 0:
        return _buildAllCoursesView();
      case 1:
        return _buildRecentFeedbackView();
      case 2:
        return _buildGradeTrendsView();
      default:
        return _buildAllCoursesView();
    }
  }

  Widget _buildAllCoursesView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: _coursesData.length,
      itemBuilder: (context, index) {
        final course = _coursesData[index];
        return CourseGradeCardWidget(
          course: course,
          onCardTap: (course) {
            // Handle card tap
          },
          onViewFeedback: (course) {
            _viewCourseFeedback(course);
          },
          onContactInstructor: (course) {
            _contactInstructor(course);
          },
          onDownloadReport: (course) {
            _downloadReport(course);
          },
        );
      },
    );
  }

  Widget _buildRecentFeedbackView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: _recentFeedback.length,
      itemBuilder: (context, index) {
        final feedback = _recentFeedback[index];
        return FeedbackDetailWidget(
          feedback: feedback,
        );
      },
    );
  }

  Widget _buildGradeTrendsView() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: GradeTrendsChartWidget(
        gradeData: _gradeTrendsData,
      ),
    );
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Grades and feedback updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedSortBy: _selectedSortBy,
        selectedCourse: _selectedCourse,
        selectedDateRange: _selectedDateRange,
        courses: _coursesData
            .map((course) => course['courseName'] as String)
            .toList(),
        onFiltersApplied: (sortBy, course, dateRange) {
          setState(() {
            _selectedSortBy = sortBy;
            _selectedCourse = course;
            _selectedDateRange = dateRange;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _applyFilters() {
    // Apply filtering logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied: $_selectedSortBy, $_selectedCourse'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewCourseFeedback(Map<String, dynamic> course) {
    // Navigate to detailed feedback view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing feedback for ${course['courseName']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _contactInstructor(Map<String, dynamic> course) {
    // Open email or messaging interface
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${course['instructorName']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadReport(Map<String, dynamic> course) {
    // Generate and download grade report
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading report for ${course['courseName']}'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _requestFeedback() {
    // Show dialog to request feedback
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request Feedback'),
        content: Text(
            'Would you like to request additional feedback from your instructors?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Feedback request sent to instructors'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Send Request'),
          ),
        ],
      ),
    );
  }
}
