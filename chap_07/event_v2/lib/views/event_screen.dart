import 'package:event_v2/models/event_detail.dart';
import 'package:event_v2/repositories/firestore_helper.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
      ),
      body: EventList(),
    );
  }
}

class EventList extends StatefulWidget {

  @override
  _EventListState createState() {
    return _EventListState();
  }

}

class _EventListState extends State<EventList> {
  final DatabaseRepo repo = DatabaseRepo();
  List<EventDetail> details = [];
  @override
  void initState() {
    if (mounted) {
      repo.getDetailsList().then((value) {
        setState(() {
          details = value;
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

          return ListTile(
            title: Text(details[position].description!),
            subtitle: Text(sub),
          );
        });
  }

}

