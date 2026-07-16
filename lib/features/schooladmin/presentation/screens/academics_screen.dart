import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/reusable_widgets/k_custom_loader.dart';
import '../../../../core/reusable_widgets/k_error_widget.dart';
import '../../../../core/reusable_widgets/k_welcome_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_font_sizes.dart';
import '../../../../core/utils/color_mapper.dart';
import '../../../../core/utils/icon_mapper.dart';
import '../../domain/entities/academies_entity.dart';
import '../providers/academics_provider.dart';

class AcademicsScreen extends ConsumerStatefulWidget {
  const AcademicsScreen({super.key});

  @override
  ConsumerState<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends ConsumerState<AcademicsScreen> {
  @override
  Widget build(BuildContext context) {
    final academicsState = ref.watch(academicsProvider);
    return academicsState.when(
      loading: () => const Center(child: KCustomLoader(message: 'Loading...',)),
      error: (error, stack) => KErrorWidget(
        title: "Failed to load academics",
        message: error.toString(),
        onRetry: () {
          ref.read(academicsProvider.notifier).refresh();
        },
      ),
      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            await ref.read(academicsProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_buildWelcomeCard(data),
                //const SizedBox(height: 30),

                _buildStatistics(data),
                const SizedBox(height: 30),

                _buildQuickAction(data),
                const SizedBox(height: 30),

                _buildTodayClasses(data),
                const SizedBox(height: 30),


              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeCard(AcademicsEntity data) {
    return KWelcomeCard(name: data.user.name, role: data.user.role);
  }

  Widget _buildQuickAction(AcademicsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: AppFontSizes.heading4,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: data.quickActions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, index) {
              return _QuickActionCard(
                item: data.quickActions[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(AcademicsEntity data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Statistics",
          style: TextStyle(
            fontSize: AppFontSizes.heading4,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.statistics.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.45,
          ),
          itemBuilder: (_, index) {

            return _StatisticsCard(
              item: data.statistics[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTodayClasses(AcademicsEntity data) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Today's Classes",
          style: TextStyle(
            fontSize: AppFontSizes.heading4,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),

          itemCount: data.todayClasses.length,

          separatorBuilder: (_, __) =>
          const SizedBox(height: 12),

          itemBuilder: (_, index) {

            return _TodayClassCard(
              item: data.todayClasses[index],
            );
          },
        ),
      ],
    );
  }

}

class _QuickActionCard extends StatelessWidget {
  final QuickActionEntity item;

  const _QuickActionCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(item.route);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        // Navigation
      },
      child: SizedBox(
        width: 82,
        child: Column(
          children: [
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(.12),
                border: Border.all(
                  color: color.withOpacity(.25),
                ),
              ),
              child: Icon(
                IconMapper.getIcon(item.icon),
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              item.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(String route) {
    switch (route) {
      case "classes":
        return AppColors.primary;

      case "subjects":
        return AppColors.success;

      case "attendance":
        return AppColors.warning;

      case "timetable":
        return AppColors.purple;

      default:
        return AppColors.primary;
    }
  }
}

class _StatisticsCard extends StatelessWidget {

  final StatisticsEntity item;

  const _StatisticsCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    final color = ColorMapper.fromHex(item.color);

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: AppColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              IconMapper.getIcon(item.icon),
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  item.count.toString(),
                  style: TextStyle(
                    fontSize: AppFontSizes.heading3,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TodayClassCard extends StatelessWidget {

  final TodayClassEntity item;

  const _TodayClassCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: AppColors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: AppColors.border,
        ),

        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),

      child: Row(
        children: [

          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.10),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.schedule,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  item.subject,
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Class : ${item.className}",
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    color: AppColors.textSecondary,
                  ),
                ),

                Text(
                  "Teacher : ${item.teacher}",
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),

            decoration: BoxDecoration(

              color: AppColors.success.withOpacity(.12),

              borderRadius: BorderRadius.circular(25),
            ),

            child: Text(
              item.time,
              style: const TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}