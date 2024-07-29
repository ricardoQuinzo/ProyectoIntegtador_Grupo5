import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationDetailScreen extends StatelessWidget {
  final String destinationId;

  DestinationDetailScreen({required this.destinationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Destination Details')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('destinations')
            .doc(destinationId)
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var destination = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(destination['imageUrl']),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name'],
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(destination['description']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Book Now'),
                      onPressed: () {
                        // Navigate to booking form
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
