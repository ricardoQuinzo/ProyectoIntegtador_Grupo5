import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact';

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception("No hay usuario autenticado");
        }

        await FirebaseFirestore.instance.collection('contacts').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'message': _messageController.text,
          'userId': currentUser.uid, // Guardar el ID del usuario actual
          'timestamp': Timestamp.now(),
        });

        setState(() {
          _isLoading = false;
        });

        _formKey.currentState?.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Mensaje enviado con éxito!'),
              duration: Duration(seconds: 3)),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacto')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su nombre.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration:
                          InputDecoration(labelText: 'Correo Electrónico'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su correo electrónico.';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Por favor ingrese un correo válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(labelText: 'Mensaje'),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su mensaje.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendMessage,
                      child: Text('Enviar Mensaje'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
