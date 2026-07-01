// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Welcome to EdConnect';

  @override
  String get loginButton => 'Login';

  @override
  String get logoutTitle => 'Logout?';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get enterEmail => 'Email';

  @override
  String get enterPassword => 'Password';

  @override
  String get selectRole => 'Select Role';

  @override
  String get welcome => 'Welcome';

  @override
  String get error => 'Error';

  @override
  String get appSubtitle => 'Multi-Tenant School Management System';

  @override
  String get totalStudent => 'Total Student';

  @override
  String get totalTeacher => 'Total Teacher';

  @override
  String get pendingFees => 'Pending Fees';

  @override
  String get activeClass => 'Active Class';

  @override
  String get uperAdmin => 'Super admin control panel';

  @override
  String get globalOverview => 'Global Overview(SaaS Status)';

  @override
  String get totalRegisterSchool => 'Total registered school';

  @override
  String get activeSubscription => 'Active subscription';

  @override
  String get monthlyRevenue => 'Monthly Revenue';

  @override
  String get systemAlert => 'System Alert';

  @override
  String get quickAction => 'Quick action';

  @override
  String get newSchoolOnboard => 'New school onboard';

  @override
  String get schoolLogo => 'Tap to Upload School Logo';

  @override
  String get schoolName => 'School Name';

  @override
  String get schoolDomain =>
      'Domain Name (first four letter school name, i.e abcd)';

  @override
  String get adminEmail => 'Admin Registration Email';

  @override
  String get allocatedPackage => 'Allocated Package Tier Setup';

  @override
  String get btnAddSchool => 'Add School';
}
