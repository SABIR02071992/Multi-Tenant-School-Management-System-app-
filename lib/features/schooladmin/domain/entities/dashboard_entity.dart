class DashboardEntity {
  final UserEntity user;
  final List<OverviewEntity> overview;
  final List<QuickActionEntity> quickActions;
  final List<ActivityEntity> recentActivities;
  final List<EventEntity> upcomingEvents;

  DashboardEntity({
    required this.user,
    required this.overview,
    required this.quickActions,
    required this.recentActivities,
    required this.upcomingEvents,
  });
}

class UserEntity {
  final int id;
  final String name;
  final String email;
  final String role;
  final String schoolDomain;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.schoolDomain,
  });
}

class OverviewEntity {
  final int id;
  final String title;
  final dynamic count;
  final String icon;
  final String color;
  final String route;

  OverviewEntity({
    required this.id,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class QuickActionEntity {
  final int id;
  final String title;
  final String icon;
  final String color;
  final String route;

  QuickActionEntity({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class ActivityEntity {
  final int id;
  final String title;
  final String subtitle;
  final String icon;

  ActivityEntity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class EventEntity {
  final int id;
  final String title;
  final String date;

  EventEntity({
    required this.id,
    required this.title,
    required this.date,
  });
}