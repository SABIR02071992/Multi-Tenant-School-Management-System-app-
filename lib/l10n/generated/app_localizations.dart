import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to EdConnect'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout?'**
  String get logoutTitle;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get enterPassword;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectRole;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Multi-Tenant School Management System'**
  String get appSubtitle;

  /// No description provided for @totalStudent.
  ///
  /// In en, this message translates to:
  /// **'Total Student'**
  String get totalStudent;

  /// No description provided for @totalTeacher.
  ///
  /// In en, this message translates to:
  /// **'Total Teacher'**
  String get totalTeacher;

  /// No description provided for @pendingFees.
  ///
  /// In en, this message translates to:
  /// **'Pending Fees'**
  String get pendingFees;

  /// No description provided for @activeClass.
  ///
  /// In en, this message translates to:
  /// **'Active Class'**
  String get activeClass;

  /// No description provided for @uperAdmin.
  ///
  /// In en, this message translates to:
  /// **'Super admin control panel'**
  String get uperAdmin;

  /// No description provided for @globalOverview.
  ///
  /// In en, this message translates to:
  /// **'Global Overview(SaaS Status)'**
  String get globalOverview;

  /// No description provided for @totalRegisterSchool.
  ///
  /// In en, this message translates to:
  /// **'Total registered school'**
  String get totalRegisterSchool;

  /// No description provided for @activeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Active subscription'**
  String get activeSubscription;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @systemAlert.
  ///
  /// In en, this message translates to:
  /// **'System Alert'**
  String get systemAlert;

  /// No description provided for @quickAction.
  ///
  /// In en, this message translates to:
  /// **'Quick action'**
  String get quickAction;

  /// No description provided for @newSchoolOnboard.
  ///
  /// In en, this message translates to:
  /// **'New school onboard'**
  String get newSchoolOnboard;

  /// No description provided for @schoolLogo.
  ///
  /// In en, this message translates to:
  /// **'Tap to Upload School Logo'**
  String get schoolLogo;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolName;

  /// No description provided for @schoolDomain.
  ///
  /// In en, this message translates to:
  /// **'Domain Name (first four letter school name, i.e abcd)'**
  String get schoolDomain;

  /// No description provided for @adminEmail.
  ///
  /// In en, this message translates to:
  /// **'Admin Registration Email'**
  String get adminEmail;

  /// No description provided for @allocatedPackage.
  ///
  /// In en, this message translates to:
  /// **'Allocated Package Tier Setup'**
  String get allocatedPackage;

  /// No description provided for @btnAddSchool.
  ///
  /// In en, this message translates to:
  /// **'Add School'**
  String get btnAddSchool;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
