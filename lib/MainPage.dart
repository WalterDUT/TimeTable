import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/res/event_firestore_service.dart';
import 'package:flutter_calendar/ui/pages/add_event.dart';
import 'package:flutter_calendar/ui/pages/update_event.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'model/event.dart';

//void main() => runApp(MyApp());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage1(),
      routes: {
        "add_event": (_) => AddEventPage(),
      },
    );
  }
}

class HomePage1 extends StatefulWidget {
  @override
  _HomePage1State createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
   // User user = _auth.currentUser;
    //userUid = user.uid;
  }

  getCurrentUser() async {
    final User user = _auth.currentUser;
    final userUid = user.uid.toString();
    return userUid;
    }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime,List<dynamic>> data ={};
    events.forEach((event) {
       DateTime date = DateTime(event.eventDate.year, event.eventDate.month, event.eventDate.day, 12 );
       //String userUid1 = event.userUid; 
       //if(userUid1 != getCurrentUser()) {};
       if(data[date] == null) data[date] = [];
       data[date].add(event);
     });
     return data;
  }

  //signOut() async {
    //await _auth.signOut();
    //final googleSignIn = GoogleSignIn();
    //await googleSignIn.signOut();
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar view'),
      ),
      
      body: StreamBuilder<List<EventModel>>(
        stream: eventDBS.streamList(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<EventModel> allEvents = snapshot.data;
            if(allEvents.isNotEmpty) {
              _events = _groupEvents(allEvents);
            }
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TableCalendar(
                  events: _events,
                  initialCalendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                      canEventMarkersOverflow: true,
                      todayColor: Colors.orange,
                      selectedColor: Theme.of(context).primaryColor,
                      todayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white)),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (date, events) {
                    setState(() {
                      _selectedEvents = events;
                    });
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  calendarController: _controller,
                ),
                ..._selectedEvents.map((event) => ListTile(
                      title: Text(event.title + " ${event.beginTime.substring(10, 15)} - " + "${event.endTime.substring(10, 15)}"),
                      tileColor: Colors.cyan[50],
                      trailing: IconButton(icon: new Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UpdateEventPage(
                                      note: event,
                                    )));
                      },
                    ))),
              ],
            ),
          );
        }
      ),
      floatingActionButton: SpeedDial(
        //child: Icon(Icons.add),
        //onPressed: () => Navigator.pushNamed(context, 'add_event'),
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22),
          backgroundColor: Colors.cyan[700],
          visible: true,
          curve: Curves.bounceIn,
          children: [
                // FAB 1
                SpeedDialChild(
                child: Icon(Icons.add),
                backgroundColor: Colors.cyan[700],
                onTap: () => Navigator.pushNamed(context, 'add_event'),
                label: 'Add event',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.cyan[700]),
                // FAB 2
                SpeedDialChild(
                child: Icon(Icons.analytics_outlined ),
                backgroundColor: Colors.cyan[700],
                //onTap:  () => Navigator.push(context, MaterialPageRoute(builder: (context) => Start())),
                onTap: (){_auth.signOut();
                          final googleSignIn = GoogleSignIn();
                          googleSignIn.signOut();},
                label: 'Sign out',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16.0),
                labelBackgroundColor: Colors.cyan[700])
          ],
      ),
      
      
    );
  }
  @override
   void dispose() {
     _auth.signOut();
     super.dispose();
     
   }
}
