import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../superadmin/presentation/providers/school_onboard_state_provider.dart';

class SelectCollegeScreen extends ConsumerStatefulWidget {
  const SelectCollegeScreen({super.key});

  @override
  ConsumerState<SelectCollegeScreen> createState() =>
      _SelectCollegeScreenState();
}

class _SelectCollegeScreenState
    extends ConsumerState<SelectCollegeScreen> {
  List<dynamic> _allSchools = [];

  dynamic _selectedSchool;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadSchools);
  }

  Future<void> _loadSchools() async {
    try {
      final schools =
      await ref.read(dashboardSchoolsFutureProvider.future);

      if (!mounted) return;

      setState(() {
        _allSchools = schools;
      });
    } catch (e) {
      debugPrint("Error loading schools : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final schoolState = ref.watch(schoolProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: schoolState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1E3A8A),
            ),
          ),
          error: (error, _) => Center(
            child: Text("${l10n.error}: $error"),
          ),
          data: (_) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.school,
                  size: 70,
                  color: Color(0xFF1E3A8A),
                ),

                const SizedBox(height: 16),

                Text(
                  "Select School / College",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),

                const SizedBox(height: 35),

                /// SEARCHABLE DROPDOWN
                DropdownSearch<dynamic>(
                  items: (filter, infiniteScrollProps) {
                    if (filter.isEmpty) {
                      return _allSchools;
                    }

                    return _allSchools.where((school) {
                      return school.schoolName
                          .toLowerCase()
                          .contains(filter.toLowerCase());
                    }).toList();
                  },

                  selectedItem: _selectedSchool,

                  itemAsString: (school) => school.schoolName,

                  compareFn: (item1, item2) =>
                  item1.domain == item2.domain,

                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    fit: FlexFit.loose,

                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        hintText: "Search School / College",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    emptyBuilder: (context, searchEntry) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Text("No School Found"),
                        ),
                      );
                    },
                  ),

                  decoratorProps: const DropDownDecoratorProps(
                    decoration: InputDecoration(
                      labelText: "Choose College",
                      hintText: "Select School",
                      prefixIcon: Icon(
                        Icons.account_balance,
                        color: Color(0xFF1E3A8A),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  onChanged: (value) {
                    setState(() {
                      _selectedSchool = value;
                    });
                  },
                ),

                const SizedBox(height: 35),

                ElevatedButton(
                  onPressed: _selectedSchool == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          schoolDomain:
                          _selectedSchool.domain,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you a Super Admin? ",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(
                              schoolDomain: null, // ya "super_admin" agar required ho
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Login Here",
                        style: TextStyle(
                          color: Color(0xFF1E3A8A),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}