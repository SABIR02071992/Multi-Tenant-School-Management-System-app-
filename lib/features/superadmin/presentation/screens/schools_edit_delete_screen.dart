import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/widgets/k_scrollable_page.dart';
import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/k_popup_menu.dart';
import '../providers/school_onboard_state_provider.dart';

class SchoolsScreenForEditDelete extends ConsumerStatefulWidget {
  const SchoolsScreenForEditDelete({super.key});

  @override
  ConsumerState<SchoolsScreenForEditDelete> createState() =>
      _SchoolsScreenForEditDeleteState();
}

class _SchoolsScreenForEditDeleteState extends ConsumerState<SchoolsScreenForEditDelete> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(schoolProvider.notifier).fetchSchoolsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final schools = ref.watch(schoolProvider);

    return schools.when(
      loading: () => const Scaffold(
        body: Center(
          child: KCustomLoader(
            message: "Loading...",
          ),
        ),
      ),

      error: (e, _) => Scaffold(
        body: KErrorWidget(
          title: "Failed to load schools",
          message: e.toString(),
          onRetry: () {
            ref.read(schoolProvider.notifier).refresh();
          },
        ),
      ),

      data: (list) {
        if (list.isEmpty) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await ref.read(schoolProvider.notifier).refresh();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 250),
                  Center(
                    child: Text("No Schools Found"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(schoolProvider.notifier).refresh();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final school = list[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.school,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      school.schoolName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          school.domain,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.public,
                              size: 16,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                school.domain,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: KPopupMenu(
                      onSelected: (value) {
                        switch (value) {
                          case "edit":
                            break;
                          case "delete":
                            break;
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}