import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vidya_setu/features/auth/presentation/screens/splash_screen.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/school_admin_dashboard.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/create_school_college_admin_screen.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/registerd_schools.dart';
import 'package:vidya_setu/features/teacher/presentation/teacher_dashboard.dart';
import 'core/constants/route_constants.dart';
import 'core/utils/local_storage.dart';
import 'core/utils/locale_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/select_school/presentation/screen/select_school_college.dart';
import 'features/student_parent/parent_dashboard.dart';
import 'features/superadmin/presentation/screens/onboard_new_school.dart';
import 'features/superadmin/presentation/screens/super_admin_dashboard.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  // Ensure Flutter framework components are ready
  WidgetsFlutterBinding.ensureInitialized();

  // Storage initialize karein
  await GetStorage.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// 1. StatelessWidget ko ConsumerWidget me badla taaki Riverpod providers read ho sakein
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Current selected language locale ko watch karein
    final currentLocale = ref.watch(localeProvider);
    final storage = LocalStorageService();

    return MaterialApp(
      title: 'EdConnect SMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('hi')],

      // First time open this screen
      home: SplashScreen(),// _openScreenBasedOnRole(storage),

      // Here register all routes
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.superAdminDashboard: (context) => const SuperAdminDashboard(),
        AppRoutes.schoolAdminDashboard: (context) => const SchoolAdminDashboard(),
        AppRoutes.teacherDashboard: (context) => const TeacherDashboard(),
        AppRoutes.parentDashboard: (context) => const ParentDashboard(),
        AppRoutes.schoolSetup: (context) => const SchoolSetupScreen(),
        AppRoutes.allRegisterSchools: (context) => const AllRegisterSchools(),
        AppRoutes.selectCollegeScreen: (context) => const SelectCollegeScreen(),
        // 🟢 Wright way: ModalRoute के ज़रिए पास किए गए arguments को रिसीव करना
        AppRoutes.createSchoolCollegeAdmin: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return CreateSchoolCollegeAdminScreen(schoolDomain: args!);
        },

      },
    );

  }
}
