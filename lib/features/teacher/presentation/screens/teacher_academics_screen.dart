// screens/academics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/utils/app_snackbar.dart';

import '../../../../core/reusable_widgets/k_add_butto.dart';
import '../../../../core/reusable_widgets/k_top_snackbar.dart';

class TeacherAcademicsScreen extends ConsumerStatefulWidget {
  const TeacherAcademicsScreen({super.key});

  @override
  ConsumerState<TeacherAcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends ConsumerState<TeacherAcademicsScreen> {
  int selectedTab = 0;

  // Sample data
  final List<Map<String, dynamic>> subjects = [
    {'name': 'Mathematics', 'teacher': 'Mr. Sharma', 'students': 40, 'room': '101'},
    {'name': 'Science', 'teacher': 'Ms. Patel', 'students': 38, 'room': '102'},
    {'name': 'English', 'teacher': 'Mr. Kumar', 'students': 42, 'room': '103'},
    {'name': 'History', 'teacher': 'Ms. Reddy', 'students': 35, 'room': '104'},
    {'name': 'Geography', 'teacher': 'Mr. Singh', 'students': 37, 'room': '105'},
    {'name': 'Geography', 'teacher': 'Mr. Singh', 'students': 37, 'room': '105'},
    {'name': 'Geography', 'teacher': 'Mr. Singh', 'students': 37, 'room': '105'},
  ];

  final List<Map<String, dynamic>> exams = [
    {
      'name': 'Mid-Term Exam',
      'date': '2026-08-15',
      'class': 'Class 8 - A',
      'status': 'Upcoming',
      'subjects': 5,
    },
    {
      'name': 'Weekly Test',
      'date': '2026-07-20',
      'class': 'Class 8 - A',
      'status': 'Completed',
      'subjects': 3,
    },
    {
      'name': 'Monthly Assessment',
      'date': '2026-07-10',
      'class': 'Class 8 - B',
      'status': 'Completed',
      'subjects': 4,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: [
          _buildSubjectsTab(),
          _buildExamsTab(),
          _buildScheduleTab(),
        ],
      ),
    );
  }

  Widget _buildSubjectsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Add New Subject Button
        KAddButton(
          text: 'Add New Subject',
          onTap: () {
            KTopSnackBar.info(
              context: context,
              title: "Information",
              message: "Coming soon.",
            );
          },
        ),
        const SizedBox(height: 16),

        // Subject Cards
        ...subjects.map((subject) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getSubjectIcon(subject['name']),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Teacher: ${subject['teacher']}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSubjectInfo(Icons.people, '${subject['students']} Students'),
                  const SizedBox(width: 16),
                  _buildSubjectInfo(Icons.meeting_room, subject['room']),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {
                      // TODO: View subject details
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('View Details'),
                  ),
                ],
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildSubjectInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildExamsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Upcoming Exams Section
        const Text(
          'Upcoming Exams',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...exams.where((e) => e['status'] == 'Upcoming').map((exam) =>
            _buildExamCard(exam)
        ).toList(),

        const SizedBox(height: 20),

        // Past Exams Section
        const Text(
          'Past Exams',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...exams.where((e) => e['status'] == 'Completed').map((exam) =>
            _buildExamCard(exam)
        ).toList(),
      ],
    );
  }

  Widget _buildExamCard(Map<String, dynamic> exam) {
    Color statusColor = exam['status'] == 'Upcoming' ? Colors.blue : Colors.green;
    IconData statusIcon = exam['status'] == 'Upcoming' ? Icons.hourglass_empty : Icons.check_circle;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${exam['class']} • ${exam['subjects']} Subjects',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                Text(
                  exam['date'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              exam['status'],
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Day Selector
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
              final isSelected = day == 'Mon';
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Schedule Items
        _buildScheduleItem('09:00 - 10:00', 'Mathematics', 'Room 101', 'Mr. Sharma'),
        _buildScheduleItem('10:00 - 11:00', 'Science', 'Room 102', 'Ms. Patel'),
        _buildScheduleItem('11:00 - 11:30', 'Break', '-', '-'),
        _buildScheduleItem('11:30 - 12:30', 'English', 'Room 103', 'Mr. Kumar'),
        _buildScheduleItem('12:30 - 01:30', 'History', 'Room 104', 'Ms. Reddy'),
        _buildScheduleItem('01:30 - 02:30', 'Lunch Break', '-', '-'),
        _buildScheduleItem('02:30 - 03:30', 'Geography', 'Room 105', 'Mr. Singh'),
        _buildScheduleItem('02:30 - 03:30', 'Java', 'Room 109', 'Mr. Singh1'),
        _buildScheduleItem('02:30 - 03:30', 'Python', 'Room 108', 'Mr. Singh2'),
      ],
    );
  }

  Widget _buildScheduleItem(String time, String subject, String room, String teacher) {
    bool isBreak = subject == 'Break' || subject == 'Lunch Break';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isBreak ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBreak ? Colors.grey.shade200 : Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isBreak ? Colors.grey : Colors.blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isBreak ? Colors.grey : Colors.black,
                ),
              ),
              if (!isBreak) ...[
                const SizedBox(height: 2),
                Text(
                  '$room • $teacher',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getSubjectIcon(String subjectName) {
    switch (subjectName) {
      case 'Mathematics':
        return Icons.calculate;
      case 'Science':
        return Icons.science;
      case 'English':
        return Icons.menu_book;
      case 'History':
        return Icons.history_edu;
      case 'Geography':
        return Icons.public;
      default:
        return Icons.book;
    }
  }
}