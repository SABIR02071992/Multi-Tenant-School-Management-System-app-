import 'package:vidya_setu/features/schooladmin/domain/entities/people_entity.dart';

class PeopleModel extends PeopleEntity {
  PeopleModel({
    required super.user,
    required super.recentJoined,
    required super.statistics
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return PeopleModel(
      user: UserModel.fromJson(data["user"]),
      recentJoined: (data["recent_joined"] as List)
          .map((e) => RecentJoinedModel.fromJson(e))
          .toList(),
      statistics: (data["statistics"] as List)
          .map((e) => StatisticsModel.fromJson(e))
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

class RecentJoinedModel extends RecentJoinedEntity {
  RecentJoinedModel({
    required super.id,
    required super.created_at,
    required super.role,
    required super.name,

  });

  factory RecentJoinedModel.fromJson(Map<String, dynamic> json) {
    return RecentJoinedModel(
      id: json["id"],
      created_at: json["created_at"],
      role: json["role"],
      name: json["name"],

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
