import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyTicketsScreen extends StatelessWidget {
  static const routeName = '/my_tickets';

  @override
  Widget build(BuildContext context) {
    // Obtén el usuario actual de Firebase Authentication
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Mis Tickets de Contacto'),
        ),
        body: Center(
          child: Text('No estás autenticado'),
        ),
      );
    }
    final currentUserId = currentUser.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tickets de Contacto'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('contacts')
            .where('userId', isEqualTo: currentUserId)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final contactTickets = snapshot.data!.docs;
          return ListView.builder(
            itemCount: contactTickets.length,
            itemBuilder: (ctx, index) {
              var ticket = contactTickets[index];
              var data = ticket.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? 'Sin nombre'),
                subtitle: Text(data['message'] ?? 'Sin mensaje'),
              );
            },
          );
        },
      ),
    );
  }
}
