import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReservationsScreen extends StatelessWidget {
  static const routeName = '/reservations';

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mis Reservas'),
        ),
        body: Center(
          child: Text('No estás autenticado'),
        ),
      );
    }

    final currentUserId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Reservas'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reservaciones')
            .where('userId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No tienes reservas registradas.'),
            );
          }
          final reservations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (ctx, index) {
              var reservation = reservations[index];
              var data = reservation.data() as Map<String, dynamic>;
              var destinationId = data['destinationId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('destinos')
                    .doc(destinationId)
                    .get(),
                builder: (ctx, snapshot) {
                  if (!snapshot.hasData) {
                    return ListTile(
                      title: Text('Cargando detalles del destino...'),
                      subtitle: Text(
                          'Desde: ${data['startDate']} - Hasta: ${data['endDate']}'),
                    );
                  }

                  var destinationData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  var startDate = (data['startDate'] as Timestamp).toDate();
                  var endDate = (data['endDate'] as Timestamp).toDate();
                  var formattedStartDate =
                      DateFormat('yyyy-MM-dd').format(startDate);
                  var formattedEndDate =
                      DateFormat('yyyy-MM-dd').format(endDate);

                  return ListTile(
                    leading: destinationData['imagenUrl'] != null
                        ? Image.network(destinationData['imagenUrl'],
                            width: 50, height: 50, fit: BoxFit.cover)
                        : null,
                    title: Text(destinationData['nombre']),
                    subtitle: Text(
                        'Desde: $formattedStartDate - Hasta: $formattedEndDate\nIncluye desayuno'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ReservationDetailsScreen(
                          destinationData: destinationData,
                          reservationData: data,
                        ),
                      ));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ReservationDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> destinationData;
  final Map<String, dynamic> reservationData;

  ReservationDetailsScreen(
      {required this.destinationData, required this.reservationData});

  @override
  Widget build(BuildContext context) {
    var startDate = (reservationData['startDate'] as Timestamp).toDate();
    var endDate = (reservationData['endDate'] as Timestamp).toDate();
    var formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    var formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Reserva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            destinationData['imagenUrl'] != null
                ? Image.network(destinationData['imagenUrl'])
                : Container(height: 200, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              destinationData['nombre'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Desde: $formattedStartDate - Hasta: $formattedEndDate'),
            SizedBox(height: 8),
            Text('Descripción: ${destinationData['descripcion']}'),
            SizedBox(height: 8),
            Text('Incluye desayuno'),
          ],
        ),
      ),
    );
  }
}
