import 'dart:convert';
import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import './widgets/class_performance_overview.dart';
import './widgets/pending_reviews_card.dart';
import './widgets/quick_action_buttons.dart';
import './widgets/quick_create_bottom_sheet.dart';
import './widgets/student_activity_feed.dart';
import './widgets/today_schedule_card.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String _selectedClass = 'Advanced Mathematics';
  bool _isRecording = false;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  XFile? _capturedImage;
  final AudioRecorder _audioRecorder = AudioRecorder();
  String? _recordingPath;

  // Mock data
  final List<Map<String, dynamic>> _todayClasses = [
    {
      "id": 1,
      "subject": "Advanced Mathematics",
      "startTime": "09:00 AM",
      "endTime": "10:30 AM",
      "room": "Room 301",
      "studentCount": 28,
      "status": "upcoming"
    },
    {
      "id": 2,
      "subject": "Physics Lab",
      "startTime": "11:00 AM",
      "endTime": "12:30 PM",
      "room": "Lab 205",
      "studentCount": 24,
      "status": "ongoing"
    },
    {
      "id": 3,
      "subject": "Chemistry Theory",
      "startTime": "02:00 PM",
      "endTime": "03:30 PM",
      "room": "Room 402",
      "studentCount": 32,
      "status": "upcoming"
    },
  ];

  final List<Map<String, dynamic>> _pendingReviews = [
    {
      "id": 1,
      "studentName": "Emma Johnson",
      "studentPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "assignmentTitle": "Calculus Problem Set 5",
      "submittedAt": "2 hours ago",
      "priority": "high"
    },
    {
      "id": 2,
      "studentName": "Michael Chen",
      "studentPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "assignmentTitle": "Physics Lab Report",
      "submittedAt": "4 hours ago",
      "priority": "medium"
    },
    {
      "id": 3,
      "studentName": "Sarah Williams",
      "studentPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "assignmentTitle": "Chemistry Essay",
      "submittedAt": "1 day ago",
      "priority": "low"
    },
    {
      "id": 4,
      "studentName": "David Rodriguez",
      "studentPhoto":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "assignmentTitle": "Math Quiz Retake",
      "submittedAt": "6 hours ago",
      "priority": "high"
    },
  ];

  final List<Map<String, dynamic>> _recentActivities = [
    {
      "id": 1,
      "studentName": "Alice Brown",
      "action": "submitted",
      "target": "Physics Assignment 3",
      "timestamp": "15 minutes ago",
      "type": "submission",
      "requiresResponse": true
    },
    {
      "id": 2,
      "studentName": "John Smith",
      "action": "posted in",
      "target": "Math Discussion Forum",
      "timestamp": "1 hour ago",
      "type": "discussion",
      "requiresResponse": false
    },
    {
      "id": 3,
      "studentName": "Lisa Garcia",
      "action": "completed",
      "target": "Chemistry Quiz 2",
      "timestamp": "2 hours ago",
      "type": "quiz",
      "requiresResponse": false
    },
    {
      "id": 4,
      "studentName": "Tom Wilson",
      "action": "asked a question about",
      "target": "Calculus Chapter 5",
      "timestamp": "3 hours ago",
      "type": "question",
      "requiresResponse": true
    },
  ];

  final List<Map<String, dynamic>> _classPerformance = [
    {
      "id": 1,
      "className": "Advanced Mathematics",
      "averageGrade": 87.5,
      "totalStudents": 28,
      "engagementRate": 92.0,
      "attendanceRate": 89.0,
      "performanceTrend": [82, 85, 88, 87, 89, 87, 88]
    },
    {
      "id": 2,
      "className": "Physics Lab",
      "averageGrade": 91.2,
      "totalStudents": 24,
      "engagementRate": 95.0,
      "attendanceRate": 94.0,
      "performanceTrend": [88, 90, 92, 91, 93, 91, 91]
    },
    {
      "id": 3,
      "className": "Chemistry Theory",
      "averageGrade": 84.8,
      "totalStudents": 32,
      "engagementRate": 88.0,
      "attendanceRate": 86.0,
      "performanceTrend": [80, 82, 85, 84, 86, 85, 85]
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      if (await _requestCameraPermission()) {
        _cameras = await availableCameras();
        if (_cameras.isNotEmpty) {
          final camera = kIsWeb
              ? _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.front,
                  orElse: () => _cameras.first)
              : _cameras.firstWhere(
                  (c) => c.lensDirection == CameraLensDirection.back,
                  orElse: () => _cameras.first);

          _cameraController = CameraController(
              camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);
          await _cameraController!.initialize();
          await _applySettings();
          if (mounted) setState(() {});
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {
      debugPrint('Focus mode error: $e');
    }
    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {
        debugPrint('Flash mode error: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() => _capturedImage = photo);
      _showSnackBar('Photo captured successfully');
    } catch (e) {
      _showSnackBar('Failed to capture photo');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _capturedImage = image);
        _showSnackBar('Image selected from gallery');
      }
    } catch (e) {
      _showSnackBar('Failed to pick image');
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() => _isRecording = true);

        if (kIsWeb) {
          await _audioRecorder.start(
              const RecordConfig(encoder: AudioEncoder.wav),
              path: 'recording.wav');
        } else {
          final dir = await getTemporaryDirectory();
          String path =
              '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(const RecordConfig(), path: path);
        }
        _showSnackBar('Recording started');
      } else {
        _showSnackBar('Microphone permission denied');
      }
    } catch (e) {
      setState(() => _isRecording = false);
      _showSnackBar('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _recordingPath = path;
      });
      _showSnackBar('Recording saved');
    } catch (e) {
      setState(() => _isRecording = false);
      _showSnackBar('Failed to stop recording');
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'csv', 'txt', 'doc', 'docx'],
      );

      if (result != null) {
        final bytes = kIsWeb
            ? result.files.first.bytes
            : await File(result.files.first.path!).readAsBytes();
        if (bytes != null) {
          _showSnackBar('File selected: ${result.files.first.name}');
        }
      }
    } catch (e) {
      _showSnackBar('Failed to select file');
    }
  }

  Future<void> _downloadFile(String content, String filename) async {
    try {
      if (kIsWeb) {
        final bytes = utf8.encode(content);
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsString(content);
      }
      _showSnackBar('File downloaded: $filename');
    } catch (e) {
      _showSnackBar('Failed to download file');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        // Dashboard - already here
        break;
      case 1:
        Navigator.pushNamed(context, '/course-list');
        break;
      case 2:
        Navigator.pushNamed(context, '/feedback-and-grades');
        break;
      case 3:
        // Analytics - show analytics view
        break;
    }
  }

  void _showQuickCreateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuickCreateBottomSheet(
        onCreateQuiz: () => _showSnackBar('Creating quiz...'),
        onCreateAssignment: () => _showSnackBar('Creating assignment...'),
        onCreatePoll: () => _showSnackBar('Creating poll...'),
        onCreateDiscussion: () => _showSnackBar('Creating discussion...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.primaryColor,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Dr. Smith',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.onPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              'Fall Semester 2024',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.onPrimaryLight.withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'school',
              color: AppTheme.onPrimaryLight,
              size: 24,
            ),
            onSelected: (value) {
              setState(() => _selectedClass = value);
            },
            itemBuilder: (context) => [
              'Advanced Mathematics',
              'Physics Lab',
              'Chemistry Theory',
              'Biology Basics',
            ]
                .map((className) => PopupMenuItem(
                      value: className,
                      child: Text(className),
                    ))
                .toList(),
          ),
          IconButton(
            onPressed: () => _showSnackBar('Notifications opened'),
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.onPrimaryLight,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: AppTheme.errorLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          _showSnackBar('Data refreshed');
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 1.h),
              TodayScheduleCard(
                todayClasses: _todayClasses,
                onClassTap: (classData) {
                  _showSnackBar('Opening ${classData['subject']} roster');
                },
              ),
              PendingReviewsCard(
                pendingReviews: _pendingReviews,
                onReviewTap: (review) {
                  _showSnackBar('Opening ${review['assignmentTitle']}');
                },
                onGradeAction: (review) {
                  _showSnackBar('Grading ${review['assignmentTitle']}');
                },
                onAudioFeedbackAction: (review) async {
                  if (_isRecording) {
                    await _stopRecording();
                  } else {
                    await _startRecording();
                  }
                },
                onReturnForRevisionAction: (review) {
                  _showSnackBar(
                      'Returning ${review['assignmentTitle']} for revision');
                },
              ),
              QuickActionButtons(
                onCreateAssignment: () =>
                    _showSnackBar('Creating new assignment...'),
                onRecordFeedback: () async {
                  if (_isRecording) {
                    await _stopRecording();
                  } else {
                    await _startRecording();
                  }
                },
                onStartPoll: () => _showSnackBar('Starting new poll...'),
                onViewAnalytics: () => _showSnackBar('Opening analytics...'),
              ),
              StudentActivityFeed(
                activities: _recentActivities,
                onActivityTap: (activity) {
                  _showSnackBar('Opening ${activity['target']}');
                },
                onQuickResponse: (activity) {
                  _showSnackBar('Responding to ${activity['studentName']}');
                },
              ),
              ClassPerformanceOverview(
                classPerformance: _classPerformance,
                onClassTap: (classData) {
                  _showSnackBar('Opening ${classData['className']} analytics');
                },
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.surfaceLight,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryLight,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _selectedIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'class',
              color: _selectedIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: _selectedIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Assessments',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'analytics',
              color: _selectedIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.textSecondaryLight,
              size: 24,
            ),
            label: 'Analytics',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickCreateBottomSheet,
        backgroundColor: AppTheme.accentLight,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.textPrimaryLight,
          size: 28,
        ),
      ),
    );
  }
}
