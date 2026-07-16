// screens/mark_attendance_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_elevatedbutton.dart';
import 'package:vidya_setu/core/reusable_widgets/k_toolbar.dart';
import 'package:vidya_setu/core/theme/app_colors.dart';

import '../../../../core/utils/avatar_color_helper.dart';

class MarkAttendanceScreen extends ConsumerStatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  ConsumerState<MarkAttendanceScreen> createState() =>
      _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState
    extends ConsumerState<MarkAttendanceScreen> {
  String selectedClass = "Class 8 - A";
  DateTime selectedDate = DateTime.now();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // Sample student data
  List<Student> students = [
    Student(name: 'Aman Verma', rollNo: '01', initials: 'AV'),
    Student(name: 'Sana Khan', rollNo: '02', initials: 'SK'),
    Student(name: 'Ravi Kumar', rollNo: '03', initials: 'RK'),
    Student(name: 'Neha Patel', rollNo: '04', initials: 'NP'),
    Student(name: 'Aditya Singh', rollNo: '05', initials: 'AS'),
    Student(name: 'Muskan Gupta', rollNo: '06', initials: 'MG'),
    Student(name: 'Rahul Sharma', rollNo: '07', initials: 'RS'),
    Student(name: 'Priya Singh', rollNo: '08', initials: 'PS'),
    Student(name: 'Amit Kumar', rollNo: '09', initials: 'AK'),
    Student(name: 'Sneha Reddy', rollNo: '10', initials: 'SR'),
  ];

  List<String> classes = [
    'Class 8 - A',
    'Class 8 - B',
    'Class 9 - A',
    'Class 9 - B',
    'Class 10 - A',
    'Class 10 - B',
  ];

  // Computed properties
  int get totalStudents => students.length;
  int get presentCount => students.where((s) => s.status == 'Present').length;
  int get absentCount => students.where((s) => s.status == 'Absent').length;
  int get leaveCount => students.where((s) => s.status == 'Leave').length;

  List<Student> get filteredStudents {
    if (searchQuery.isEmpty) {
      return students;
    }
    return students.where((student) =>
    student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.rollNo.contains(searchQuery)).toList();
  }

  // Date Picker Function - Fixed
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A6CF7),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A6CF7),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Format date to display
  String get formattedDate {
    return '${selectedDate.day} ${_getMonthName(selectedDate.month)} ${selectedDate.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  // Mark all students as present
  void _markAllPresent() {
    setState(() {
      for (var student in students) {
        student.status = 'Present';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All students marked as present!'),
        backgroundColor: Color(0xFF34C759),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: KAppBar(title: 'Mark Attendance',showBackButton: true,),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Class and Date Row
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE8ECF1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.class_outlined,
                                size: 20,
                                color: Color(0xFF4A6CF7),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedClass,
                                    isExpanded: true,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    items: classes.map((String className) {
                                      return DropdownMenuItem<String>(
                                        value: className,
                                        child: Text(className),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          selectedClass = value;
                                          // Reset attendance when class changes
                                          for (var student in students) {
                                            student.status = '';
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              // Removed extra arrow icon from here
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE8ECF1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: Color(0xFF4A6CF7),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Search Bar
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE8ECF1)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF9AA6B5),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Search student by name or roll no.',
                              hintStyle: TextStyle(
                                color: Color(0xFF9AA6B5),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 18,
                              color: Color(0xFF9AA6B5),
                            ),
                            onPressed: () {
                              setState(() {
                                searchController.clear();
                                searchQuery = '';
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary Cards
                  Row(
                    children: [
                      _buildSummaryCard(
                        title: 'Total',
                        count: totalStudents.toString(),
                        color: const Color(0xFF4A6CF7),
                        icon: Icons.people_outline,
                      ),
                      const SizedBox(width: 8),
                      _buildSummaryCard(
                        title: 'Present',
                        count: presentCount.toString(),
                        color: const Color(0xFF34C759),
                        icon: Icons.check_circle_outline,
                      ),
                      const SizedBox(width: 8),
                      _buildSummaryCard(
                        title: 'Absent',
                        count: absentCount.toString(),
                        color: const Color(0xFFFF3B30),
                        icon: Icons.person_off_outlined,
                      ),
                      const SizedBox(width: 8),
                      _buildSummaryCard(
                        title: 'Leave',
                        count: leaveCount.toString(),
                        color: const Color(0xFFFF9500),
                        icon: Icons.beach_access_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Students Header
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Students',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Attendance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mark All Present Button - Fixed with onTap
                  GestureDetector(
                    onTap: _markAllPresent,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A6CF7).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF4A6CF7).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.groups_outlined,
                            size: 22,
                            color: const Color(0xFF4A6CF7),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Mark All Present',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A6CF7),
                              ),
                            ),
                          ),
                          const Text(
                            'All students will be marked as present',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9AA6B5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: const Color(0xFF4A6CF7),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student List or Empty State
                  if (filteredStudents.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredStudents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, index) {
                        final student = filteredStudents[index];
                        return _buildStudentCard(student);
                      },
                    ),
                  const SizedBox(height: 16),

                  // Footer Stats
                  if (filteredStudents.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      child: Text(
                        'Present: ${presentCount.toString()} | Absent: ${absentCount.toString()} | Leave: ${leaveCount.toString()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A6CF7),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Bottom Save Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child:KElevatedButton(label: 'Attendance', onPressed:(){ _saveAttendance();},icon: Icons.save_outlined,backgroundColor: AppColors.blue,),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: const Color(0xFF9AA6B5).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9AA6B5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF9AA6B5).withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchController.clear();
                searchQuery = '';
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6CF7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Clear Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String count,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE8ECF1)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: color,
                ),
                const SizedBox(width: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9AA6B5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE8ECF1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Student Avatar
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AvatarColorHelper.background(student.name),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    student.initials,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AvatarColorHelper.foreground(student.name),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Roll No. ${student.rollNo}',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF9AA6B5),
                      ),
                    ),
                  ],
                ),
              ),
              // Attendance Buttons
              Row(
                children: [
                  _buildAttendanceButton(
                    label: 'Present',
                    isSelected: student.status == 'Present',
                    color: const Color(0xFF34C759),
                    onTap: () {
                      setState(() {
                        if (student.status == 'Present') {
                          student.status = '';
                        } else {
                          student.status = 'Present';
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildAttendanceButton(
                    label: 'Absent',
                    isSelected: student.status == 'Absent',
                    color: const Color(0xFFFF3B30),
                    onTap: () {
                      setState(() {
                        if (student.status == 'Absent') {
                          student.status = '';
                        } else {
                          student.status = 'Absent';
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 6),
                  _buildAttendanceButton(
                    label: 'Leave',
                    isSelected: student.status == 'Leave',
                    color: const Color(0xFFFF9500),
                    onTap: () {
                      setState(() {
                        if (student.status == 'Leave') {
                          student.status = '';
                        } else {
                          student.status = 'Leave';
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE8ECF1),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? color : const Color(0xFF9AA6B5),
          ),
        ),
      ),
    );
  }

  void _saveAttendance() {
    // Check if any student is unmarked
    final unmarkedCount = students.where((s) => s.status.isEmpty).length;

    if (unmarkedCount > 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Attendance'),
          content: Text(
            '$unmarkedCount student(s) have not been marked. Do you want to continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _submitAttendance();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A6CF7),
              ),
              child: const Text('Save Anyway'),
            ),
          ],
        ),
      );
    } else {
      _submitAttendance();
    }
  }

  void _submitAttendance() {
    // Prepare attendance data
    final attendanceData = {
      'class': selectedClass,
      'date': formattedDate,
      'students': students.map((student) => {
        'name': student.name,
        'rollNo': student.rollNo,
        'status': student.status,
      }).toList(),
    };

    print('Attendance Data: $attendanceData');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance saved successfully!'),
        backgroundColor: Color(0xFF34C759),
        duration: Duration(seconds: 2),
      ),
    );

    // Reset all attendance after saving
    setState(() {
      for (var student in students) {
        student.status = '';
      }
    });
  }
}

// Student Model
class Student {
  final String name;
  final String rollNo;
  final String initials;
  String status;

  Student({
    required this.name,
    required this.rollNo,
    required this.initials,
    this.status = '',
  });
}