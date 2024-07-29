import 'package:flutter/material.dart';
import '../services/destination_service.dart';
import '../models/destination.dart';
import 'edit_destination_screen.dart';

class DestinationListScreen extends StatelessWidget {
  final DestinationService _destinationService = DestinationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Destinos')),
      body: StreamBuilder<List<Destination>>(
        stream: _destinationService.destinations,
        builder: (context, snapshot) {
          print(
              "StreamBuilder called with snapshot state: ${snapshot.connectionState}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error fetching destinations: ${snapshot.error}");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("No destinations found in the snapshot.");
            return Center(child: Text('No hay destinos disponibles'));
          } else {
            List<Destination> destinations = snapshot.data!;
            print("Number of destinations found: ${destinations.length}");
            return ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                Destination destination = destinations[index];
                return ListTile(
                  title: Text(destination.name),
                  subtitle: Text(destination.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDestinationScreen(
                                  destination: destination),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool confirm = await _showConfirmDialog(context);
                          if (confirm) {
                            await _destinationService
                                .deleteDestinationWithReservations(
                                    destination.id);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<bool> _showConfirmDialog(BuildContext context) async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmación'),
            content: Text(
                '¿Estás seguro de que quieres eliminar este destino y todas sus reservas asociadas?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Eliminar'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
