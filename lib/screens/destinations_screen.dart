import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class DestinationsScreen extends StatelessWidget {
  static const routeName = '/destinations';

  void _showReservationDialog(BuildContext context, String destinationId) {
    final _formKey = GlobalKey<FormState>();
    DateTime? _startDate;
    DateTime? _endDate;
    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Reservar Destino'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Fecha de Inicio'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _startDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (_startDate != null) {
                      _startDateController.text =
                          DateFormat('yyyy-MM-dd').format(_startDate!);
                    }
                  },
                  validator: (value) {
                    if (_startDate == null) {
                      return 'Por favor seleccione una fecha de inicio.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'Fecha de Fin'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _endDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (_endDate != null) {
                      _endDateController.text =
                          DateFormat('yyyy-MM-dd').format(_endDate!);
                    }
                  },
                  validator: (value) {
                    if (_endDate == null) {
                      return 'Por favor seleccione una fecha de fin.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Reservar'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No estás autenticado')),
                    );
                    return;
                  }
                  final currentUserId = currentUser.uid;

                  // Guardar la reservación en Firestore
                  await FirebaseFirestore.instance
                      .collection('reservaciones')
                      .add({
                    'destinationId': destinationId,
                    'startDate': Timestamp.fromDate(_startDate!),
                    'endDate': Timestamp.fromDate(_endDate!),
                    'userId': currentUserId,
                  });

                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reserva realizada con éxito!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Destinos')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('destinos').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final destinations = snapshot.data!.docs;
          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (ctx, index) {
              var destination = destinations[index];
              return ListTile(
                leading: destination['imagenUrl'] != null
                    ? Image.network(destination['imagenUrl'],
                        width: 50, height: 50, fit: BoxFit.cover)
                    : null,
                title: Text(destination['nombre']),
                subtitle: Text(destination['descripcion']),
                onTap: () {
                  _showReservationDialog(context, destination.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
