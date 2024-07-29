import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserListScreen extends StatelessWidget {
  static const routeName = '/user_list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Usuarios')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users =
              snapshot.data?.docs ?? []; // Manejo de null para snapshot.data
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, index) {
              var user = users[index];
              Map<String, dynamic> data = user.data() as Map<String, dynamic>;
              String email = data.containsKey('email')
                  ? data['email']
                  : 'Email no disponible';
              String displayName = data.containsKey('displayName')
                  ? data['displayName']
                  : 'Nombre no disponible';

              return ListTile(
                title: Text(email),
                subtitle: Text(displayName),
              );
            },
          );
        },
      ),
    );
  }
}
