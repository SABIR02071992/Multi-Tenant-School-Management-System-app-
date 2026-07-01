import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/network/api_client.dart';
import '../../../../core/reusable_widgets/k_loader.dart';
import '../../../../core/reusable_widgets/k_toolbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/school_onboard_state_provider.dart';

class AllRegisterSchools extends ConsumerStatefulWidget {
  const AllRegisterSchools({super.key});

  @override
  ConsumerState<AllRegisterSchools> createState() => _AllRegisterSchoolsState();
}

class _AllRegisterSchoolsState extends ConsumerState<AllRegisterSchools> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final schoolsAsync = ref.watch(dashboardSchoolsFutureProvider);
    const String baseUrl = "http://192.168.29.217:5000";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const KAppBar(
        title: 'Registered Schools',
        subtitle: 'Complete verified database',
        showBackButton: true,
      ),
      body: schoolsAsync.when(
        data: (schoolList) {
          if (schoolList.isEmpty) {
            return const Center(child: Text('No registered schools found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: schoolList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final school = schoolList[index];
              final isExpanded = _expandedIndex == index;

              return Card(
                elevation: isExpanded ? 4 : 2,
                shadowColor: AppColors.redShad,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // 🔥 Toggle logic: Agar wahi clicked hai toh wrap (-1), nahi toh unwrap (index)
                    setState(() {
                      _expandedIndex = isExpanded ? -1 : index;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER ROW (Hamesha dikhega) ---
                        Row(
                          children: [
                            // 🟢 SCHOOL LOGO SETUP (Pehle letter ki jagah)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 48,
                                height: 48,
                                color: const Color(
                                  0xFF0F172A,
                                ).withOpacity(0.05),
                                child: Builder(
                                  builder: (context) {
                                    final rawPath = school.logoPath;

                                    if (rawPath == null || rawPath.isEmpty) {
                                      return const Icon(
                                        Icons.school,
                                        color: Color(0xFF0F172A),
                                        size: 24,
                                      );
                                    }

                                    // Windows '\' -> '/'
                                    final cleanPath = rawPath.replaceAll(
                                      "\\",
                                      "/",
                                    );

                                    // Final Image URL
                                    final imageUrl =
                                        "${ApiClient.baseUrl}/api/v1/school/$cleanPath";

                                    debugPrint("IMAGE URL => $imageUrl");

                                    return Image.network(
                                      imageUrl,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,

                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

                                            return const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },

                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            debugPrint("IMAGE ERROR => $error");

                                            return const Icon(
                                              Icons.school,
                                              color: Color(0xFF0F172A),
                                              size: 24,
                                            );
                                          },
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // School Title and Domain
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    school.schoolName ?? 'Unknown School',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    school.domain ?? 'No domain assigned',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 Dynamic Arrow Indicator (Rotates up/down based on expansion)
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                            ),
                          ],
                        ),

                        // 🔥 DYNAMIC UNWRAP AREA (Sirf isExpanded true hone par open hoga)
                        AnimatedEndSection(
                          isExpanded: isExpanded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                child: Divider(
                                  height: 1,
                                  color: AppColors.textSecondary,
                                ), // Light divider divider lines
                              ),

                              // Email Field Details
                              _buildDetailRow(
                                Icons.email_outlined,
                                'Admin Email',
                                school.adminEmail ?? 'N/A',
                              ),
                              const SizedBox(height: 8),

                              _buildDetailRow(
                                Icons.location_on_outlined,
                                'Location',
                                'Location not found' ?? 'Location not found',
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                Icons.subscriptions,
                                'Setup Plane',
                                school.planSetup ??
                                    'No setup details config added',
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                Icons.numbers,
                                'College Code',
                                school.id ?? 'No college id added',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              KLoader(size: 12),
              SizedBox(height: 16),
              Text(
                'Fetching secure directory...',
                style: TextStyle(color: AppColors.grey300),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // Private Helper layout row fields ke data ko standard structure dene ke liye
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary2),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.info,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔥 Premium Smooth Micro-Animation Widget Wrapper
class AnimatedEndSection extends StatelessWidget {
  final bool isExpanded;
  final Widget child;

  const AnimatedEndSection({
    super.key,
    required this.isExpanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Container(child: isExpanded ? child : const SizedBox.shrink()),
    );
  }
} // end code
