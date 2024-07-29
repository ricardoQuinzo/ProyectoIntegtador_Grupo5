import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'admin_screen.dart';
import 'destinations_screen.dart';
import 'contact_screen.dart';
import 'reservations_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [
          IconButton(
            icon: Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.of(context).pushNamed(AdminScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.book_online),
            onPressed: () {
              Navigator.of(context).pushNamed(ReservationsScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido a nuestra Aplicación Turística',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Explorar Destinos'),
                onPressed: () {
                  Navigator.of(context).pushNamed(DestinationsScreen.routeName);
                },
              ),
              ElevatedButton(
                child: Text('Contactar'),
                onPressed: () {
                  Navigator.of(context).pushNamed(ContactScreen.routeName);
                },
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menú'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Explorar Destinos'),
              onTap: () {
                Navigator.of(context).pushNamed(DestinationsScreen.routeName);
              },
            ),
            ListTile(
              title: Text('Reservaciones'),
              onTap: () {
                Navigator.of(context).pushNamed(ReservationsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
