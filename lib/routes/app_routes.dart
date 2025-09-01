import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/teacher_dashboard/teacher_dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/feedback_and_grades/feedback_and_grades.dart';
import '../presentation/student_dashboard/student_dashboard.dart';
import '../presentation/course_list/course_list.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String login = '/login-screen';
  static const String feedbackAndGrades = '/feedback-and-grades';
  static const String studentDashboard = '/student-dashboard';
  static const String courseList = '/course-list';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    teacherDashboard: (context) => const TeacherDashboard(),
    login: (context) => const LoginScreen(),
    feedbackAndGrades: (context) => const FeedbackAndGrades(),
    studentDashboard: (context) => const StudentDashboard(),
    courseList: (context) => const CourseList(),
    // TODO: Add your other routes here
  };
}
