import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/destinations_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/add_destination_screen.dart';
import 'screens/reservations_screen.dart';
import 'screens/my_tickets_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Turismo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        AddDestinationScreen.routeName: (ctx) => AddDestinationScreen(),
        DestinationsScreen.routeName: (ctx) => DestinationsScreen(),
        ContactScreen.routeName: (ctx) => ContactScreen(),
        AdminScreen.routeName: (ctx) => AdminScreen(),
        RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
        UserListScreen.routeName: (ctx) => UserListScreen(),
        AddDestinationScreen.routeName: (ctx) => AddDestinationScreen(),
        ReservationsScreen.routeName: (ctx) => ReservationsScreen(),
        MyTicketsScreen.routeName: (ctx) => MyTicketsScreen(),
      },
    );
  }
}
