class AcademicsEntity {
  final UserEntity user;
  final List<StatisticsEntity> statistics;
  final List<QuickActionEntity> quickActions;
  final List<TodayClassEntity> todayClasses;

  AcademicsEntity({
    required this.user,
    required this.statistics,
    required this.quickActions,
    required this.todayClasses,
  });
}

class UserEntity {
  final int id;
  final String name;
  final String email;
  final String role;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class StatisticsEntity {
  final int id;
  final String title;
  final dynamic count;
  final String icon;
  final String color;
  final String route;

  StatisticsEntity({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class QuickActionEntity {
  final String title;
  final String icon;
  final String route;

  QuickActionEntity({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class TodayClassEntity {
  final String className;
  final String subject;
  final String teacher;
  final String time;

  TodayClassEntity({
    required this.className,
    required this.subject,
    required this.teacher,
    required this.time,
  });
}