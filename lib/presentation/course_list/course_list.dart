import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/course_card_widget.dart';
import './widgets/course_search_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/semester_filter_widget.dart';

class CourseList extends StatefulWidget {
  const CourseList({Key? key}) : super(key: key);

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSemester = 'Current';
  String _searchQuery = '';
  Map<String, dynamic> _filters = {
    'department': 'All Departments',
    'instructor': 'All Instructors',
    'schedule': 'All Schedules',
    'credits': 0,
  };
  bool _isLoading = false;

  final List<Map<String, dynamic>> _allCourses = [
    {
      "id": 1,
      "code": "CS 101",
      "title": "Introduction to Computer Science",
      "instructor": "Dr. Sarah Johnson",
      "credits": 3,
      "semester": "Current",
      "department": "Computer Science",
      "schedule": "Morning (8AM-12PM)",
      "progress": 0.75,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "code": "MATH 201",
      "title": "Calculus II",
      "instructor": "Prof. Michael Chen",
      "credits": 4,
      "semester": "Current",
      "department": "Mathematics",
      "schedule": "Afternoon (12PM-5PM)",
      "progress": 0.45,
      "status": "behind",
      "thumbnail":
          "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 3,
      "code": "PHYS 150",
      "title": "General Physics I",
      "instructor": "Dr. Emily Rodriguez",
      "credits": 4,
      "semester": "Current",
      "department": "Physics",
      "schedule": "Morning (8AM-12PM)",
      "progress": 0.25,
      "status": "at_risk",
      "thumbnail":
          "https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 4,
      "code": "ENG 102",
      "title": "English Composition",
      "instructor": "Prof. David Wilson",
      "credits": 3,
      "semester": "Current",
      "department": "English",
      "schedule": "Evening (5PM-9PM)",
      "progress": 0.85,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 5,
      "code": "CHEM 110",
      "title": "General Chemistry",
      "instructor": "Dr. Lisa Thompson",
      "credits": 4,
      "semester": "Current",
      "department": "Chemistry",
      "schedule": "Afternoon (12PM-5PM)",
      "progress": 0.60,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "code": "HIST 101",
      "title": "World History",
      "instructor": "Prof. James Anderson",
      "credits": 3,
      "semester": "Past",
      "department": "History",
      "schedule": "Morning (8AM-12PM)",
      "progress": 1.0,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 7,
      "code": "BIO 120",
      "title": "Introduction to Biology",
      "instructor": "Dr. Sarah Johnson",
      "credits": 4,
      "semester": "Past",
      "department": "Biology",
      "schedule": "Afternoon (12PM-5PM)",
      "progress": 1.0,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
    {
      "id": 8,
      "code": "PSY 101",
      "title": "Introduction to Psychology",
      "instructor": "Dr. Emily Rodriguez",
      "credits": 3,
      "semester": "Past",
      "department": "Psychology",
      "schedule": "Evening (5PM-9PM)",
      "progress": 1.0,
      "status": "on_track",
      "thumbnail":
          "https://images.unsplash.com/photo-1559757175-0eb30cd8c063?fm=jpg&q=60&w=300&ixlib=rb-4.0.3",
    },
  ];

  List<Map<String, dynamic>> get _filteredCourses {
    List<Map<String, dynamic>> courses = _allCourses;

    // Filter by semester
    if (_selectedSemester != 'All') {
      courses = courses
          .where((course) => course['semester'] == _selectedSemester)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      courses = courses.where((course) {
        final String searchLower = _searchQuery.toLowerCase();
        return (course['code'] as String).toLowerCase().contains(searchLower) ||
            (course['title'] as String).toLowerCase().contains(searchLower) ||
            (course['instructor'] as String)
                .toLowerCase()
                .contains(searchLower);
      }).toList();
    }

    // Apply additional filters
    if (_filters['department'] != 'All Departments') {
      courses = courses
          .where((course) => course['department'] == _filters['department'])
          .toList();
    }

    if (_filters['instructor'] != 'All Instructors') {
      courses = courses
          .where((course) => course['instructor'] == _filters['instructor'])
          .toList();
    }

    if (_filters['schedule'] != 'All Schedules') {
      courses = courses
          .where((course) => course['schedule'] == _filters['schedule'])
          .toList();
    }

    if (_filters['credits'] != 0) {
      courses = courses
          .where((course) => course['credits'] == _filters['credits'])
          .toList();
    }

    return courses;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'My Courses',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
              size: 24,
            ),
            onPressed: () => Navigator.pushNamed(context, '/student-dashboard'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCourses,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Search Bar
            CourseSearchWidget(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterBottomSheet,
            ),

            // Semester Filter
            SemesterFilterWidget(
              selectedSemester: _selectedSemester,
              onSemesterChanged: _onSemesterChanged,
            ),

            // Course List
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    )
                  : _filteredCourses.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.only(bottom: 2.h),
                          itemCount: _filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = _filteredCourses[index];
                            return CourseCardWidget(
                              course: course,
                              onTap: () => _navigateToCourseDetail(course),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedSemester == 'Current'
          ? FloatingActionButton.extended(
              onPressed: _browseCatalog,
              backgroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.backgroundColor,
              foregroundColor:
                  AppTheme.lightTheme.floatingActionButtonTheme.foregroundColor,
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme
                    .lightTheme.floatingActionButtonTheme.foregroundColor!,
                size: 24,
              ),
              label: Text(
                'Add Course',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme
                      .lightTheme.floatingActionButtonTheme.foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return EmptyStateWidget(
        title: 'No Results Found',
        subtitle: 'Try adjusting your search terms or filters to find courses.',
        buttonText: 'Clear Search',
        iconName: 'search_off',
        onButtonPressed: () {
          setState(() {
            _searchController.clear();
            _searchQuery = '';
          });
        },
      );
    }

    if (_selectedSemester == 'Current') {
      return EmptyStateWidget(
        title: 'No Current Courses',
        subtitle:
            'You are not enrolled in any courses this semester. Browse the catalog to find courses.',
        buttonText: 'Browse Catalog',
        iconName: 'school',
        onButtonPressed: _browseCatalog,
      );
    }

    if (_selectedSemester == 'Past') {
      return EmptyStateWidget(
        title: 'No Past Courses',
        subtitle: 'You have not completed any courses yet. Keep studying!',
        buttonText: 'View Current Courses',
        iconName: 'history_edu',
        onButtonPressed: () {
          setState(() {
            _selectedSemester = 'Current';
          });
        },
      );
    }

    return EmptyStateWidget(
      title: 'No Courses Found',
      subtitle:
          'No courses match your current filters. Try adjusting your search criteria.',
      buttonText: 'Clear Filters',
      iconName: 'filter_list_off',
      onButtonPressed: () {
        setState(() {
          _filters = {
            'department': 'All Departments',
            'instructor': 'All Instructors',
            'schedule': 'All Schedules',
            'credits': 0,
          };
        });
      },
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onSemesterChanged(String semester) {
    setState(() {
      _selectedSemester = semester;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _filters,
        onFiltersApplied: (filters) {
          setState(() {
            _filters = filters;
          });
        },
      ),
    );
  }

  Future<void> _refreshCourses() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Courses updated successfully'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _navigateToCourseDetail(Map<String, dynamic> course) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${course['title']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _browseCatalog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening course catalog...'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {},
          textColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      ),
    );
  }
}
