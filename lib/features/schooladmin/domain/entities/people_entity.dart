class PeopleEntity {
  final UserEntity user;
  final List<RecentJoinedEntity> recentJoined;
  final List<StatisticsEntity> statistics;

  PeopleEntity({
    required this.user,
    required this.recentJoined,
    required this.statistics,
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

class RecentJoinedEntity {
  final int id;
  final String created_at;
  final String role;
  final String name;

  RecentJoinedEntity({
    required this.id,
    required this.created_at,
    required this.role,
    required this.name,

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

