import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  SettingsModel({
    required super.profile,
    required super.school,
    required super.menus,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];

    return SettingsModel(
      profile: ProfileModel.fromJson(data["profile"]),
      school: SchoolModel.fromJson(data["school"]),
      menus: (data["menus"] as List)
          .map((e) => MenuModel.fromJson(e))
          .toList(),
    );
  }
}

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
    );
  }
}

class SchoolModel extends SchoolEntity {
  SchoolModel({
    required super.name,
    required super.domain,
    required super.logo,
    required super.plan,
  });

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      name: json["name"],
      domain: json["domain"],
      logo: json["logo"],
      plan: json["plan"],
    );
  }
}

class MenuModel extends MenuEntity {
  MenuModel({
    required super.title,
    required super.icon,
    required super.route,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      title: json["title"],
      icon: json["icon"],
      route: json["route"],
    );
  }
}