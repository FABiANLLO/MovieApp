import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:movieapp/Models/constant.dart';

class BasicCrud {
  final _collectionReference =
      FirebaseFirestore.instance.collection('dart_collection');

  //Anadir un documento a Firestore usando el metodo anadir

  // Future<DocumentReference> addDocument() async {
  //   return await _collectionReference.add(Constant.allDataTypes.toMap());
  // }

  // Usando Set
  Future<void> addDocument() async {
    await _collectionReference
        .doc('set_data')
        .set(Constant.allDataTypes.toMap());
  }

  Future<void> updateDocument() async {
    await _collectionReference
        .doc('KBmt8SD7unP66xMdBbbp')
        .set({'geo_point_field': GeoPoint(20, 20)}, SetOptions(merge: false));
  }
}
