import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/k_welcome_card.dart';
import '../../../../core/utils/color_mapper.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../providers/dashboard_provider.dart';

class SchoolAdminHomeScreen extends ConsumerStatefulWidget {
  const SchoolAdminHomeScreen({super.key});

  @override
  ConsumerState<SchoolAdminHomeScreen> createState() =>
      _SchoolAdminHomeScreenState();
}

class _SchoolAdminHomeScreenState extends ConsumerState<SchoolAdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(dashboardProvider);
    final isLoading = dashboard.isLoading;

    return dashboard.when(
      loading: () => const Center(child: KCustomLoader(message: 'Loading...',)),
      error: (error, stack) {
        return KErrorWidget(
          title: "Failed to load people",
          message: error.toString(),
          onRetry: () {
            ref.read(dashboardProvider.notifier).refresh();
          },
        );
      },
      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(dashboardProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildWelcomeCard(data),

                const SizedBox(height: 30),

                /// Overview Section
                const Text(
                  "Overview",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.overview.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.25,
                  ),
                  itemBuilder: (context, index) {
                    final item = data.overview[index];
                    return _DashboardCard(
                      title: item.title,
                      value: item.count.toString(),
                      icon: IconMapper.getIcon(item.icon),
                      color: ColorMapper.fromHex(item.color),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Quick Actions Section
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.quickActions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, index) {
                    final item = data.quickActions[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        _navigateToRoute(context, item.route);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: ColorMapper.fromHex(item.color),
                            child: Icon(
                              IconMapper.getIcon(item.icon),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Recent Activities Section
                const Text(
                  "Recent Activities",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                if (data.recentActivities.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text(
                        "No recent activities",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.recentActivities.length,
                    itemBuilder: (_, index) {
                      final item = data.recentActivities[index];
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade50,
                            child: Icon(
                              IconMapper.getIcon(item.icon),
                              color: Colors.blue.shade700,
                            ),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(item.subtitle),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),

                // Upcoming Events Section (if any)
                if (data.upcomingEvents.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  const Text(
                    "Upcoming Events",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.upcomingEvents.length,
                    itemBuilder: (context, index) {
                      final item = data.upcomingEvents[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.event, color: Colors.white),
                          ),
                          title: Text(item.title),
                          subtitle: Text(item.date),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // Extra bottom space
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Navigation method
  void _navigateToRoute(BuildContext context, String route) {

     switch (route) {
       case 'students':
         Navigator.pushNamed(context, AppRoutes.getStudentsListScreen);
         break;
    //   case 'teachers':
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => TeachersScreen()));
    //     break;
    //   case 'attendance':
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => AttendanceScreen()));
    //     break;
    //   case 'notice':
    //     Navigator.push(context, MaterialPageRoute(builder: (_) => NoticeBoardScreen()));
    //     break;
    //   default:
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text('Route: $route')),
    //     );
     }
    // Temporary: Show snackbar with route name
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to: ${route.toUpperCase()}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
  Widget _buildWelcomeCard(DashboardEntity data) {
    return KWelcomeCard(
      name: data.user.name,
      role: data.user.role,
    );
  }

}

// Dashboard Card Widget
class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
