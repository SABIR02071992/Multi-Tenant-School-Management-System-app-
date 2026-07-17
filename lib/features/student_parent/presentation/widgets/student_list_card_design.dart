import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/avatar_color_helper.dart';
import '../../../../core/widgets/k_popup_menu.dart';
import '../../domain/entities/student_entity.dart';

/*class StudentListCard extends StatelessWidget {
  final StudentEntity student;

  const StudentListCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final bool isActive = (student.status ?? "").toLowerCase() == "active";
    //final bool isActive = (student.status ?? "").toLowerCase() == "active";

    final String initials = (
        (student.firstName.isNotEmpty ? student.firstName[0] : "") +
            (student.lastName.isNotEmpty ? student.lastName[0] : "")
    ).toUpperCase();

    final String colorKey =
        student.id?.toString() ?? student.admissionNo;

    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // TODO : Open Student Details
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AvatarColorHelper.background(colorKey),
                    child: Text(
                      initials.isEmpty ? "?" : initials,
                      style: TextStyle(
                        color: AvatarColorHelper.foreground(colorKey),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(.08),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            student.admissionNo,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  KPopupMenu(
                    onSelected: (value) {
                      switch (value) {
                        case "view":
                          // TODO
                          break;

                        case "edit":
                          // TODO
                          break;

                        case "delete":
                          // TODO
                          break;
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              const Divider(),

              const SizedBox(height: 12),

              ///======================
              /// DETAILS
              ///======================

              _InfoTile(
                icon: Icons.numbers_outlined,
                title: "Roll No",
                value: student.rollNo ?? '',
              ),
              const SizedBox(height: 10),

              _InfoTile(
                icon: Icons.school_outlined,
                title: "Class",
                value: student.className ?? '',
              ),

              const SizedBox(height: 10),

              _InfoTile(
                icon: Icons.person_outline,
                title: "Father",
                value: student.fatherName ?? '',
              ),

              const SizedBox(height: 10),

              _InfoTile(
                icon: Icons.call_outlined,
                title: "Mobile",
                value: student.mobile ?? '',
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withOpacity(.12)
                          : Colors.red.withOpacity(.12),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: isActive ? Colors.green : Colors.red,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.secondary),

        const SizedBox(width: 10),

        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
          ),
        ),

        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}*/
import 'package:flutter/material.dart';

class StudentListCard extends StatefulWidget {
  final StudentEntity student;

  const StudentListCard({
    super.key,
    required this.student,
  });

  @override
  State<StudentListCard> createState() => _StudentListCardState();
}

class _StudentListCardState extends State<StudentListCard> {
  @override
  Widget build(BuildContext context) {
    final student = widget.student;

    final bool isActive =
        (student.status ?? "").toLowerCase() == "active";

    final String initials = (
        (student.firstName.isNotEmpty ? student.firstName[0] : "") +
            (student.lastName.isNotEmpty ? student.lastName[0] : "")
    ).toUpperCase();

    final String colorKey =
        student.id?.toString() ?? student.admissionNo;

    return Card(
      elevation: 0,
      color: AppColors.card,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            18,
            0,
            18,
            18,
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          leading: CircleAvatar(
            radius: 28,
            backgroundColor:
            AvatarColorHelper.background(colorKey),
            child: Text(
              initials.isEmpty ? "?" : initials,
              style: TextStyle(
                color:
                AvatarColorHelper.foreground(colorKey),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          title: Text(
            student.fullName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),

          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                student.admissionNo,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          trailing: KPopupMenu(
            onSelected: (value) {
              switch (value) {
                case "view":
                  break;

                case "edit":
                  break;

                case "delete":
                  break;
              }
            },
          ),

          children: [
            const Divider(),

            const SizedBox(height: 12),

            InfoTile(
              icon: Icons.numbers_outlined,
              title: "Roll No",
              value: student.rollNo?.toString() ?? "-",
            ),

            const SizedBox(height: 10),

            InfoTile(
              icon: Icons.school_outlined,
              title: "Class",
              value: student.className ?? "-",
            ),
            const SizedBox(height: 10),

            InfoTile(
              icon: Icons.view_column_outlined,
              title: "Section",
              value: student.section ?? "-",
            ),

            const SizedBox(height: 10),

            InfoTile(
              icon: Icons.person_outline,
              title: "Father",
              value: student.fatherName ?? "-",
            ),

            const SizedBox(height: 10),

            InfoTile(
              icon: Icons.call_outlined,
              title: "Mobile",
              value: student.mobile ?? "-",
            ),

            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(.12)
                        : Colors.red.withOpacity(.12),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 18,
                        color: isActive
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isActive
                            ? "Active"
                            : "Inactive",
                        style: TextStyle(
                          color: isActive
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.secondary,
        ),
        const SizedBox(width: 10),
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
          ),
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
