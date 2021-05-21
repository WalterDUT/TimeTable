// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:table_calender_app/model/event.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Note details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              event.title,
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(
              height: 20,
            ),
            Text(event.description),
          ],
        ),
      ),
    );
    // throw UnimplementedError();
  }
}
