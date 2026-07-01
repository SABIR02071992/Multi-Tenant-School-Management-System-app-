import '../../domain/entity/super_admin_entity.dart';

class SchoolModel extends SchoolEntity {
  SchoolModel({
    required super.id,
    required super.schoolName,
    required super.adminEmail,
    required super.domain,
    required super.schemaName, // 🟢 Naya Column constructor me add kiya
    required super.logoPath,
    required super.planSetup,
    required super.status,
    super.message,             // Isko required se optional (?) kiya kyunki ye har baar nahi aata
  });

  // API से आने वाले JSON को मॉडल में बदलना (Updated)
  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id']?.toString() ?? '',
      schoolName: json['schoolName'] ?? '',
      adminEmail: json['adminEmail'] ?? '',
      domain: json['domain'] ?? '',
      schemaName: json['schemaName'] ?? '', // 🟢 Backend json key 'schemaName' ko map kiya
      logoPath: json['logoPath'] ?? '',
      planSetup: json['planSetup'] ?? '',
      status: json['status'] ?? 'active',
      message: json['message'],
    );
  }

  // अगर आपको इस मॉडल को वापस JSON (Map) में बदलना हो (Updated)
  Map<String, dynamic> toJson() {
    return {
      'id': int.tryParse(id) ?? id,
      'schoolName': schoolName,
      'adminEmail': adminEmail,
      'domain': domain,
      'schemaName': schemaName,             // 🟢 JSON serialize karne ke liye naya field joda
      'logoPath': logoPath,
      'planSetup': planSetup,
      'status': status,
      if (message != null) 'message': message,
    };
  }
}

