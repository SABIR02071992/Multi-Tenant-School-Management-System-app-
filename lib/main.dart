import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vidya_setu/features/auth/presentation/screens/splash_screen.dart';
import 'package:vidya_setu/features/schooladmin/presentation/screens/school_admin_main_screen.dart';
import 'package:vidya_setu/features/student_parent/presentation/screens/student_list_screen.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/create_user.dart';
import 'package:vidya_setu/features/superadmin/presentation/screens/registerd_schools.dart';
import 'package:vidya_setu/features/teacher/presentation/screens/teacher_main_screen.dart';
import 'core/constants/route_constants.dart';
import 'core/network/internet_service.dart';
import 'core/utils/local_storage.dart';
import 'core/utils/locale_provider.dart';
import 'features/attendance/prasentation/screen/attendance_mark_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/select_school/presentation/screen/select_school_college.dart';
import 'features/student_parent/presentation/screens/create_student_screen.dart';
import 'features/student_parent/presentation/screens/parent_student_dashboard.dart';
import 'features/superadmin/presentation/screens/onboard_new_school.dart';
import 'features/superadmin/presentation/screens/super_admin_dashboard.dart';
import 'l10n/generated/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
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

// ConsumerWidget → ConsumerStatefulWidget
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    startInternetListener();
  }

  @override
  Widget build(BuildContext context) {
    // Current selected language locale
    final currentLocale = ref.watch(localeProvider);
    final storage = LocalStorageService();

    return MaterialApp(
      navigatorKey: navigatorKey,
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
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],

      // First time open this screen
      home: SplashScreen(),

      // Here register all routes
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.superAdminDashboard: (context) =>
        const SuperAdminDashboard(),
        AppRoutes.schoolAdminDashboard: (context) =>
        const SchoolAdminMainScreen(),
        AppRoutes.teacherDashboard: (context) =>
        const TeacherMainScreen(),
        AppRoutes.parenStudentDashboard: (context) =>
        const ParentStudentDashboard(),
        AppRoutes.schoolSetup: (context) =>
        const OnBoardNewSchoolCollege(),
        AppRoutes.allRegisterSchools: (context) =>
        const AllRegisterSchools(),
        AppRoutes.selectCollegeScreen: (context) =>
        const SelectCollegeScreen(),

        // 🟢 Right way: ModalRoute ke through arguments receive karna
        AppRoutes.createSchoolCollegeAdmin: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String?;
          return CreateNewUser(schoolDomain: args!);
        },
        AppRoutes.attendanceMarkScreen: (context) => const MarkAttendanceScreen(),
        AppRoutes.createStudentScreen: (context) => const CreateStudentScreen(),
        AppRoutes.getStudentsListScreen: (context) => const StudentListScreen()
      },
    );
  }
}
