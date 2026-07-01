import 'package:flutter/material.dart';
import '../../core/reusable_widgets/logout_alert.dart';
import '../auth/presentation/screens/login_screen.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('छात्र / अभिभावक पोर्टल', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF4F46E5), // पैरेंट पोर्टल के लिए इंडिगो थीम
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
            // छात्र का प्रोफाइल समरी कार्ड
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.school, size: 35, color: Color(0xFF4F46E5)),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('राहुल शर्मा', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('कक्षा: 8B | रोल नंबर: 24', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Text('Apex School Group', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // अटेंडेंस क्विक मीटर
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  const Text('इस महीने की कुल उपस्थिति:', style: TextStyle(fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Text('92%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('मुख्य मेनू (Quick Options)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            const SizedBox(height: 12),

            // स्टूडेंट ग्रिड मेनू (Grid Menu)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildMenuCard('दैनिक टाइम-टेबल', Icons.calendar_today, Colors.blue, () {}),
                _buildMenuCard('गृहकार्य (Homework)', Icons.assignment, Colors.orange, () {}),
                _buildMenuCard('रिपोर्ट कार्ड (Results)', Icons.bar_chart, Colors.purple, () {}),
                _buildMenuCard('फीस भुगतान (Pay Fees)', Icons.payment, Colors.red, () {}),
              ],
            ),
            const SizedBox(height: 24),

            // हालिया नोटिस / सूचनाएं
            const Text('स्कूल नोटिस बोर्ड', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: CircleAvatar(backgroundColor: Color(0xFFEEF2F6), child: Icon(Icons.campaign, color: Color(0xFF4F46E5))),
                title: Text('सर्दियों की छुट्टियों की घोषणा', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                subtitle: Text('स्कूल 25 दिसंबर से 5 जनवरी तक बंद रहेगा।', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
