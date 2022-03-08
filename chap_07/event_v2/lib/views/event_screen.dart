import 'package:event_v2/models/event_detail.dart';
import 'package:event_v2/models/favorite.dart';
import 'package:event_v2/repositories/firestore_helper.dart';
import 'package:event_v2/services/authentication.dart';
import 'package:event_v2/views/login_screen.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  final Authentication auth = Authentication();
  final String uid;

  EventScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((result) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())
                  );
                });
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: EventList(uid),
    );
  }
}

class EventList extends StatefulWidget {

  final String uid;
  EventList(this.uid);

  @override
  _EventListState createState() {
    return _EventListState();
  }

}

class _EventListState extends State<EventList> {
  final DatabaseRepo repo = DatabaseRepo();
  List<EventDetail> details = [];
  List<Favorite> favorites = <Favorite>[];

  @override
  void initState() {
    if (mounted) {
      repo.getDetailsList().then((value) {
        setState(() {
          details = value;
        });
      });
      repo.getUserFavorites(widget.uid).then((data){
        setState(() {
          favorites = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: (details != null) ? details.length : 0,
        itemBuilder: (context, position) {
          String sub = 'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
          Color starColor = (isUserFavorite(details[position].id!) ? Colors.amber : Colors.grey);

          return ListTile(
            title: Text(details[position].description!),
            subtitle: Text(sub),
            trailing: IconButton(
              icon: Icon(Icons.star, color: starColor,),
              onPressed: () {
                toggleeFavorite(details[position]);
              },
            ),
          );
        });
  }

  void toggleeFavorite(EventDetail ed) async{
    DatabaseRepo repo = DatabaseRepo();
    if (isUserFavorite(ed.id!)) {
      Favorite favorite = favorites.firstWhere((Favorite f) => (f.eventId == ed.id!));
      String favId = favorite.id!;
      await repo.deleteFavorite(favId);
    } else {
      await repo.addFavorite(ed, widget.uid);
    }
    List<Favorite> updatedFavorites = await repo.getUserFavorites(widget.uid);
    setState(() {
      favorites = updatedFavorites;
    });
  }

  bool isUserFavorite(String eventId) {

    Favorite favorite = favorites.firstWhere((Favorite f) => (f.eventId! == eventId), orElse: () => Favorite(null, null, null));

    if (favorite.id == null && favorite.eventId == null && favorite.userId == null) {
      return false;
    } else {
      return true;
    }
  }

}

