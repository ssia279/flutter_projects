import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String? _id;
  String? _eventId;
  String? _userId;

  Favorite(this._id, this._eventId, this._userId);

  String? get eventId => _eventId;
  String? get id => _id;
  String? get userId => _userId;

  Favorite.toMap(DocumentSnapshot document) {
    this._id = document.id;
    dynamic data = document.data();
    this._eventId = data!['eventId'];
    this._userId = data!['userId'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    if (_id != null) {
      map['id'] = _id;
    }
    map['eventId'] = _eventId;
    map['userId'] = _userId;
    return map;
  }

}