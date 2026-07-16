import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/widgets/k_scrollable_page.dart';
import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/widgets/k_hide_bottom_nav_on_scroll.dart';
import '../../../../core/widgets/k_popup_menu.dart';
import '../providers/user_provider.dart';

class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userProvider.notifier).fetchAllRegisterUsers();
    });
  }
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userProvider);

    return users.when(
      loading: () => const Scaffold(
        body: Center(
          child: KCustomLoader(
            message: "Loading...",
          ),
        ),
      ),

      error: (e, _) => Scaffold(
        body: KErrorWidget(
          title: "Failed to load users",
          message: e.toString(),
          onRetry: () {
            ref.read(userProvider.notifier).refresh();
          },
        ),
      ),

      data: (list) {
        if (list.isEmpty) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                await ref.read(userProvider.notifier).refresh();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 250),
                  Center(
                    child: Text("No Users Found"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(userProvider.notifier).refresh();
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final user = list[index];

                final isActive =
                    (user.status ?? "").toLowerCase() == "active";

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : "?",
                      ),
                    ),
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Role : ${user.role}"),
                        Text("School : ${user.schoolName ?? "N/A"}"),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Icon(
                              isActive
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: isActive
                                  ? Colors.green
                                  : Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isActive ? "Active" : "Inactive",
                              style: TextStyle(
                                color: isActive
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
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