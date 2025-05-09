import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: BeautySpotLiteApp(),
    ),
  );
}

class BeautySpotLiteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) => MaterialApp(
        title: 'BeautySpot',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.pink,
          cardTheme: CardTheme(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
        themeMode: auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: auth.currentUser == null ? LoginScreen() : MainScreen(),
      ),
    );
  }
}
