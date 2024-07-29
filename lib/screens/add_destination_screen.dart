import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AddDestinationScreen extends StatefulWidget {
  static const routeName = '/add_destination';

  @override
  _AddDestinationScreenState createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _addDestination() async {
    if (_formKey.currentState?.validate() ?? false && _selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Subir la imagen a Firebase Storage
        final storageRef = FirebaseStorage.instance.ref();
        final destinationImageRef =
            storageRef.child('destinos/${DateTime.now().toIso8601String()}');
        await destinationImageRef.putFile(_selectedImage!);
        final imageUrl = await destinationImageRef.getDownloadURL();

        // Guardar detalles del destino en Firestore
        await FirebaseFirestore.instance.collection('destinos').add({
          'nombre': _nameController.text,
          'descripcion': _descriptionController.text,
          'imagenUrl': imageUrl,
          'timestamp': Timestamp.now(),
        });

        _formKey.currentState?.reset();
        setState(() {
          _selectedImage = null;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Destino agregado con éxito!')),
        );

        // Redirigir al listado de destinos
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar destino: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor, complete todos los campos e incluya una imagen.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Destino')),
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
                      decoration:
                          InputDecoration(labelText: 'Nombre del Destino'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del destino.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Descripción'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una descripción.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _selectedImage == null
                        ? Text('No se ha seleccionado imagen.')
                        : Image.file(
                            _selectedImage!,
                            height: 150,
                          ),
                    ElevatedButton(
                      child: Text('Seleccionar Imagen'),
                      onPressed: _pickImage,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addDestination,
                      child: Text('Agregar Destino'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
