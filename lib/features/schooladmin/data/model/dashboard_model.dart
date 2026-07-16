import '../../domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  DashboardModel({
    required super.user,
    required super.overview,
    required super.quickActions,
    required super.recentActivities,
    required super.upcomingEvents,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return DashboardModel(
      user: UserModel.fromJson(data["user"]),
      overview: (data["overview"] as List)
          .map((e) => OverviewModel.fromJson(e))
          .toList(),
      quickActions: (data["quick_actions"] as List)
          .map((e) => QuickActionModel.fromJson(e))
          .toList(),
      recentActivities: (data["recent_activities"] as List)
          .map((e) => ActivityModel.fromJson(e))
          .toList(),
      upcomingEvents: (data["upcoming_events"] as List)
          .map((e) => EventModel.fromJson(e))
          .toList(),
    );
  }
}

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    required super.schoolDomain,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      schoolDomain: json["school_domain"],
    );
  }
}

class OverviewModel extends OverviewEntity {
  OverviewModel({
    required super.id,
    required super.title,
    required super.count,
    required super.icon,
    required super.color,
    required super.route,
  });

  factory OverviewModel.fromJson(Map<String, dynamic> json) {
    return OverviewModel(
      id: json["id"],
      title: json["title"],
      count: json["count"],
      icon: json["icon"],
      color: json["color"],
      route: json["route"],
    );
  }
}

class QuickActionModel extends QuickActionEntity {
  QuickActionModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.color,
    required super.route,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      id: json["id"],
      title: json["title"],
      icon: json["icon"],
      color: json["color"],
      route: json["route"],
    );
  }
}

class ActivityModel extends ActivityEntity {
  ActivityModel({
    required super.id,
    required super.title,
    required super.subtitle,
    required super.icon,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json["id"],
      title: json["title"],
      subtitle: json["subtitle"],
      icon: json["icon"],
    );
  }
}

class EventModel extends EventEntity {
  EventModel({
    required super.id,
    required super.title,
    required super.date,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      title: json["title"],
      date: json["date"] ?? "",
    );
  }
}