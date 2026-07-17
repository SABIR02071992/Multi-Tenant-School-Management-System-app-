import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/k_toolbar.dart';
import '../../../../core/reusable_widgets/koutline_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/getStudents_provider.dart';
import '../widgets/student_list_card_design.dart';

class StudentListScreen extends ConsumerStatefulWidget {
  const StudentListScreen({super.key});

  @override
  ConsumerState<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends ConsumerState<StudentListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String searchText = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(getStudentProvider.notifier).fetchStudents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsState = ref.watch(getStudentProvider);

    return studentsState.when(
      loading: () => const Scaffold(
        body: Center(child: KCustomLoader(message: "Loading Students...")),
      ),

      error: (error, stack) => Scaffold(
        appBar: const KAppBar(title: "Students"),
        body: KErrorWidget(
          title: "Failed to load students",
          message: error.toString(),
          onRetry: () {
            ref.read(getStudentProvider.notifier).refresh();
          },
        ),
      ),

      data: (students) {
        final filteredStudents = students.where((student) {
          return student.firstName.toLowerCase().contains(
            searchText.toLowerCase(),
          );
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: const KAppBar(title: "Students"),

          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(getStudentProvider.notifier).refresh();
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Students",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Manage all registered students",
                              style: TextStyle(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      ),

                      KOutlinedButton(
                        label: "Add Student",
                        icon: Icons.add,
                        borderRadius: 6,
                        backgroundColor: AppColors.addButton,
                        borderColor: AppColors.white,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.createStudentScreen,
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Search
                  TextField(
                    controller: _searchController,

                    decoration: InputDecoration(
                      hintText: "Search student...",

                      prefixIcon: const Icon(Icons.search),

                      filled: true,

                      fillColor: AppColors.card,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Count
                  Text(
                    "Showing ${filteredStudents.length} Students",

                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (filteredStudents.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),

                      child: Column(
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 70,
                            color: Colors.grey.shade400,
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "No Students Found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Register your first student",
                            style: TextStyle(color: AppColors.textHint),
                          ),

                          const SizedBox(height: 20),

                          KOutlinedButton(
                            label: "Add Student",
                            icon: Icons.add,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.createStudentScreen,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      itemCount: filteredStudents.length,

                      separatorBuilder: (_, __) => const SizedBox(height: 14),

                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];

                        return StudentListCard(student: student);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
