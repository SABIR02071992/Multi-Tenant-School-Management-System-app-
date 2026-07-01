import 'package:flutter/material.dart';
import '../../../core/reusable_widgets/logout_alert.dart';
import '../../auth/presentation/screens/login_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('शिक्षक पोर्टल (Faculty)', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF0284C7), // लाइट ब्लू थीम फॉर टीचर्स
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: (){
                AppDialogs.showLogoutDialog(context: context, onLogoutConfirmed: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                });
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('आज के मुख्य कार्य', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
            const SizedBox(height: 16),

            // अटेंडेंस लेने का क्विक बटन
            _buildTeacherTaskCard(
              context,
              title: 'दैनिक उपस्थिति दर्ज करें',
              subtitle: 'कक्षा 10B - मैथ पीरियड',
              icon: Icons.done_all,
              color: Colors.green,
              onTap: () {
                // यहाँ अटेंडेंस स्क्रीन पर नेविगेट करने का लॉजिक आएगा
              },
            ),
            const SizedBox(height: 12),

            // होमवर्क असाइन करने का बटन
            _buildTeacherTaskCard(
              context,
              title: 'नया होमवर्क अपलोड करें',
              subtitle: 'छात्रों को असाइनमेंट भेजें',
              icon: Icons.menu_book,
              color: Colors.orange,
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // मार्क्स अपलोड करने का बटन
            _buildTeacherTaskCard(
              context,
              title: 'परीक्षा के अंक (Marks Entry)',
              subtitle: 'टर्म-1 एग्जाम रिजल्ट्स',
              icon: Icons.grade,
              color: Colors.purple,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherTaskCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
