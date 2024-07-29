import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination.dart';

class DestinationService {
  final CollectionReference destinationCollection =
      FirebaseFirestore.instance.collection('destinos');

  Stream<List<Destination>> get destinations {
    return destinationCollection.snapshots().map((snapshot) {
      print("Snapshot length: ${snapshot.docs.length}");
      if (snapshot.docs.isEmpty) {
        print("No documents found in the destinos collection.");
        return <Destination>[]; // Lista vacía
      }
      return snapshot.docs.map((doc) {
        print("Document data: ${doc.data()}");
        return Destination(
          id: doc.id,
          name: doc['nombre'] ?? 'Nombre no disponible',
          description: doc['descripcion'] ?? 'Descripción no disponible',
          imageUrl: doc['imagenUrl'] ?? '',
        );
      }).toList();
    }).handleError((error) {
      print("Error fetching destinations: $error");
      return <Destination>[]; // Lista vacía en caso de error
    });
  }

  Future<void> addDestination(Destination destination) async {
    await destinationCollection.add({
      'nombre': destination.name,
      'descripcion': destination.description,
      'imagenUrl': destination.imageUrl,
    });
  }

  Future<void> updateDestination(Destination destination) async {
    await destinationCollection.doc(destination.id).update({
      'nombre': destination.name,
      'descripcion': destination.description,
      'imagenUrl': destination.imageUrl,
    });
  }

  Future<void> deleteDestination(String id) async {
    await destinationCollection.doc(id).delete();
  }

  Future<void> deleteDestinationWithReservations(String destinationId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('destinationId', isEqualTo: destinationId)
        .get();

    print(
        "Number of reservations to delete: ${reservationSnapshot.docs.length}");

    for (DocumentSnapshot doc in reservationSnapshot.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(destinationCollection.doc(destinationId));
    await batch.commit();
  }
}
