import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'destination_list_screen.dart';
import 'add_destination_screen.dart';

class AdminScreen extends StatelessWidget {
  static const routeName = '/admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Administración')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text('Ver Lista de Usuarios'),
              onPressed: () {
                Navigator.of(context).pushNamed('/user_list');
              },
            ),
            ElevatedButton(
              child: Text('Ver Lista de Destinos'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DestinationListScreen(),
                ));
              },
            ),
            ElevatedButton(
              child: Text('Agregar Destino'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddDestinationScreen(),
                ));
              },
            ),
            ElevatedButton(
              child: Text('Mis Tickets de Contacto'),
              onPressed: () {
                Navigator.of(context).pushNamed('/my_tickets');
              },
            ),
          ],
        ),
      ),
    );
  }
}
