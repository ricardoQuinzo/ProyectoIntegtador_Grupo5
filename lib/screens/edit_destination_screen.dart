import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../services/destination_service.dart';

class EditDestinationScreen extends StatelessWidget {
  final Destination destination;
  final _formKey = GlobalKey<FormState>();

  EditDestinationScreen({required this.destination});

  late String _name = destination.name;
  late String _description = destination.description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Destino')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: destination.name,
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: destination.description,
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Llama al servicio para actualizar el destino
                    Destination updatedDestination = Destination(
                      id: destination.id,
                      name: _name,
                      description: _description,
                      imageUrl: destination.imageUrl,
                    );
                    await DestinationService()
                        .updateDestination(updatedDestination);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
