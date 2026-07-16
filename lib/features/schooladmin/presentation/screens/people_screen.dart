import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/theme/app_font_sizes.dart';
import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/k_welcome_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/color_mapper.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../domain/entities/people_entity.dart';
import '../providers/people_provider.dart';

class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider);

    return people.when(
      loading: () => const Center(child: KCustomLoader(message: 'Loading...',)),

      error: (error, stack) => KErrorWidget(
        title: "Failed to load people",
        message: error.toString(),
        onRetry: () {
          ref.read(peopleProvider.notifier).refresh();
        },
      ),

      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(peopleProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               // _buildWelcomeCard(data),
               // const SizedBox(height: 30),

                _buildStatistics(data),

                const SizedBox(height: 30),

                _buildRecentJoined(data),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(PeopleEntity data) {
    return KWelcomeCard(
      name: data.user.name,
      role: data.user.role,
    );
  }

  Widget _buildStatistics(PeopleEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Statistics",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.statistics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (_, index) {
            final item = data.statistics[index];

            return _StatisticCard(
              title: item.title,
              count: item.count.toString(),
              icon: IconMapper.getIcon(item.icon),
              color: ColorMapper.fromHex(item.color),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentJoined(PeopleEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recently Joined",
          style: TextStyle(fontSize: AppFontSizes.heading4, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.recentJoined.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final item = data.recentJoined[index];

            return _RecentJoinedCard(item: item);
          },
        ),
      ],
    );
  }
}

class _RecentJoinedCard extends StatelessWidget {
  final RecentJoinedEntity item;

  const _RecentJoinedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color roleColor = switch (item.role) {
      "Teacher" => AppColors.teacher,
      "Student" => AppColors.student,
      "Parent" => AppColors.parent,
      "School Admin" => AppColors.schoolAdmin,
      _ => AppColors.grey,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: roleColor.withOpacity(.12),
            child: Text(
              item.name[0].toUpperCase(),
              style: TextStyle(
                color: roleColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.role,
                    style: TextStyle(
                      color: roleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(height: 6),

              Text(
                item.created_at,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatisticCard({
    required this.title,
    required this.count,
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 10),

          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title),
        ],
      ),
    );
  }
}
