class SettingsEntity {
  final ProfileEntity profile;
  final SchoolEntity school;
  final List<MenuEntity> menus;

  SettingsEntity({
    required this.profile,
    required this.school,
    required this.menus,
  });
}

class ProfileEntity {
  final int id;
  final String name;
  final String email;
  final String role;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

class SchoolEntity {
  final String name;
  final String domain;
  final String logo;
  final String plan;

  SchoolEntity({
    required this.name,
    required this.domain,
    required this.logo,
    required this.plan,
  });
}

class MenuEntity {
  final String title;
  final String icon;
  final String route;

  MenuEntity({
    required this.title,
    required this.icon,
    required this.route,
  });
}