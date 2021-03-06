import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_v2/models/favorite.dart';
import 'package:event_v2/views/event_screen.dart';

import '../models/event_detail.dart';

class DatabaseRepo {

  Future<List<EventDetail>> getDetailsList() async {
    List<EventDetail> eventDetails = <EventDetail>[];
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('event_details');

    collectionRef.withConverter<EventDetail>(fromFirestore: (snapshot, _) => EventDetail.fromMap(snapshot.data()!),
        toFirestore: (eventDetail, _) => eventDetail.toMap(),);

    var documents = await collectionRef.get().then((collection) => collection.docs);
    documents.forEach((event) {
      EventDetail detail = EventDetail.fromMap(event.data());
      print(event.data().toString());
      detail.id = event.id;
      eventDetails.add(detail);
    });

    return eventDetails;

    //List<QueryDocumentSnapshot<EventDetail>>


    /*
    var eventDetails = await collectionRef.get().then((value) => value.docs.forEach((element) {
      EventDetail details = EventDetail.fromMap(element.data());
      print(details.description);// element is the document and element's data is the actual data
    }));
    //as List<QueryDocumentSnapshot<EventDetail>>;
    //return eventDetails;
    */
  }

  Future<void> addFavorite(EventDetail eventDetail, String uid) {
    Favorite fav = Favorite(null, eventDetail.id, uid);
    Future<void> addedCollection = FirebaseFirestore.instance.collection('favorites').add(fav.toMap()).then((value) => print(value))
      .catchError((error) => print(error));

    return addedCollection;
  }

  Future<void> deleteFavorite(String favId) async {
    await FirebaseFirestore.instance.collection('favorites').doc(favId).delete();
  }

  Future<List<Favorite>> getUserFavorites(String uid) async {
    List<Favorite> favs = <Favorite>[];
    var docs = await FirebaseFirestore.instance.collection('favorites').where('userId', isEqualTo: uid).get();
    if (docs != null) {
      favs = docs.docs.map((data) => Favorite.toMap(data)).toList();
    }

    return favs;
  }
}