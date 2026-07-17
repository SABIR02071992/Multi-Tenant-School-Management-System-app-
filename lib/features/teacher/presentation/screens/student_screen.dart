// screens/student_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentScreen extends ConsumerStatefulWidget {
  const StudentScreen({super.key});

  @override
  ConsumerState<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends ConsumerState<StudentScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedClass = 'All Classes';
  String selectedFilter = 'All Students';
  String searchQuery = '';

  final List<String> classList = [
    'All Classes',
    'Class 8 - A',
    'Class 8 - B',
    'Class 9 - A',
    'Class 9 - B',
    'Class 10 - A',
    'Class 10 - B',
  ];

  final List<String> filterList = [
    'All Students',
    'Present',
    'Absent',
    'Leave',
    'Active',
    'Inactive',
  ];

  // Sample student data
  final List<Map<String, dynamic>> students = [
    {
      'id': '1',
      'name': 'Aarav Sharma',
      'rollNo': '101',
      'class': 'Class 8 - A',
      'status': 'Present',
      'attendance': '95%',
      'email': 'aarav@email.com',
      'phone': '9876543210',
    },
    {
      'id': '2',
      'name': 'Priya Patel',
      'rollNo': '102',
      'class': 'Class 8 - A',
      'status': 'Absent',
      'attendance': '85%',
      'email': 'priya@email.com',
      'phone': '9876543211',
    },
    {
      'id': '3',
      'name': 'Rahul Singh',
      'rollNo': '103',
      'class': 'Class 8 - A',
      'status': 'Present',
      'attendance': '92%',
      'email': 'rahul@email.com',
      'phone': '9876543212',
    },
    {
      'id': '4',
      'name': 'Sneha Reddy',
      'rollNo': '104',
      'class': 'Class 8 - B',
      'status': 'Leave',
      'attendance': '78%',
      'email': 'sneha@email.com',
      'phone': '9876543213',
    },
    {
      'id': '5',
      'name': 'Vikram Kumar',
      'rollNo': '105',
      'class': 'Class 8 - B',
      'status': 'Present',
      'attendance': '88%',
      'email': 'vikram@email.com',
      'phone': '9876543214',
    },
  ];

  List<Map<String, dynamic>> get filteredStudents {
    var filtered = students;

    if (selectedClass != 'All Classes') {
      filtered = filtered.where((s) => s['class'] == selectedClass).toList();
    }

    if (selectedFilter != 'All Students') {
      filtered = filtered.where((s) => s['status'] == selectedFilter).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((s) =>
      s['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          s['rollNo'].contains(searchQuery)
      ).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search students...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        value: selectedClass,
                        items: classList,
                        icon: Icons.class_,
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        value: selectedFilter,
                        items: filterList,
                        icon: Icons.filter_list,
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFilterChip('Total', students.length, Colors.blue),
                _buildFilterChip('Present', students.where((s) => s['status'] == 'Present').length, Colors.green),
                _buildFilterChip('Absent', students.where((s) => s['status'] == 'Absent').length, Colors.red),
                _buildFilterChip('Leave', students.where((s) => s['status'] == 'Leave').length, Colors.orange),
              ],
            ),
          ),

          // Student List
          Expanded(
            child: filteredStudents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return _buildStudentCard(student);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add student
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(icon, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    Color statusColor;
    IconData statusIcon;
    switch (student['status']) {
      case 'Present':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Absent':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case 'Leave':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

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
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue.shade100,
            child: Text(
              student['name'].split(' ').map((e) => e[0]).join(''),
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Roll No. ${student['rollNo']} • ${student['class']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(statusIcon, size: 14, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            student['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Attendance: ${student['attendance']}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show student actions menu
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}