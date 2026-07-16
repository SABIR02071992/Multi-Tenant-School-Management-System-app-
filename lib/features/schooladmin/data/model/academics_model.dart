
import '../../domain/entities/academies_entity.dart';

class AcademicsModel extends AcademicsEntity {
  AcademicsModel({
    required super.user,
    required super.statistics,
    required super.quickActions,
    required super.todayClasses,
  });

  factory AcademicsModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return AcademicsModel(
      user: UserModel.fromJson(data["user"]),
      statistics: (data["statistics"] as List)
          .map((e) => StatisticsModel.fromJson(e))
          .toList(),
      quickActions: (data["quick_actions"] as List)
          .map((e) => QuickActionModel.fromJson(e))
          .toList(),
      todayClasses: (data["today_classes"] as List)
          .map((e) => TodayClassModel.fromJson(e))
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
    );
  }
}

class StatisticsModel extends StatisticsEntity {
  StatisticsModel({
    required super.id,
    required super.title,
    required super.count,
    required super.icon,
    required super.color,
    required super.route,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
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
    required super.title,
    required super.icon,
    required super.route,
  });

  factory QuickActionModel.fromJson(Map<String, dynamic> json) {
    return QuickActionModel(
      title: json["title"],
      icon: json["icon"],
      route: json["route"],
    );
  }
}

class TodayClassModel extends TodayClassEntity {
  TodayClassModel({
    required super.className,
    required super.subject,
    required super.teacher,
    required super.time,
  });

  factory TodayClassModel.fromJson(Map<String, dynamic> json) {
    return TodayClassModel(
      className: json["class"],
      subject: json["subject"],
      teacher: json["teacher"],
      time: json["time"],
    );
  }
}