import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    bool _isDarkMode = auth.isDarkMode;

    void _logout(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Bạn có chắc muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<AuthService>(context, listen: false).logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: SwitchListTile(
                title: Text('Chế độ tối', style: TextStyle(fontSize: 16)),
                secondary: Icon(_isDarkMode ? LucideIcons.moon : LucideIcons.sun),
                value: _isDarkMode,
                onChanged: (value) {
                  Provider.of<AuthService>(context, listen: false).toggleDarkMode(value);
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: Icon(LucideIcons.logOut, color: Colors.red),
                title: Text('Đăng xuất', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                onTap: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
