import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calender_app/ui/pages/add_event.dart';
import 'package:table_calender_app/ui/pages/view_event.dart';

import 'model/event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        "add_event": (_) => AddEventPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events: _events,
              initialCalendarFormat: CalendarFormat.week,
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
              onDaySelected: (date, events, _) {
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
                  title: Text(event.title),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EventDetailsPage(
                                  event: event,
                                )));
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, 'add_event'),
      ),
    );
  }
}

//===========================================================
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   String _message = "You are not sign up";
//   FirebaseAuth _auth;
//   GoogleSignIn _googleSignIn;
//
//   Future<User> _handleSignIn() async {
//     final GoogleSignInAccount goodleUser = await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await goodleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     final User user = (await _auth.signInWithCredential(credential)).user;
//     print("signed in " + user.displayName);
//     setState(() {
//       //if login thi bao login
//       _message = "You are signed in!!";
//     });
//     return user;
//   }
//
//   Future _handleSignOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//     setState(() {
//       _message = "Log out successfully";
//     });
//   }
//
//   Future _checkLogin() async {
//     // check xem user da login chua
//     final User user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         //hien thi thong bao da log out
//         _message = "Hello " + user.displayName;
//       });
//     }
//   }
//
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Firebase Login'),
//         ),
//         body: FutureBuilder(
//           future: _initialization,
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Text("sthing went wrong");
//             }
//             if (snapshot.connectionState == ConnectionState.done) {
//               _auth = FirebaseAuth.instance;
//               _googleSignIn = GoogleSignIn();
//               _checkLogin();
//               return Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(_message),
//                     // ignore: deprecated_member_use
//                     OutlineButton(
//                       onPressed: () {
//                         _handleSignIn();
//                         // Navigator.push(
//                         //     context,
//                         //     MaterialPageRoute(
//                         //         builder: (context) => ToDoList()));
//                       },
//                       child: Text('Login'),
//                     ),
//                     // ignore: deprecated_member_use
//                     OutlineButton(
//                       onPressed: () {
//                         _handleSignOut();
//                       },
//                       child: Text('Logout'),
//                     ),
//                     OutlineButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => ToDoList()));
//                       },
//                       child: Text('Next page!'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ));
//   }
// }
//
// class ToDoList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     // throw UnimplementedError();
//     return new MaterialApp(
//       title: 'To Do List',
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: new Text('Todo List'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('Go back!'),
//           ),
//         ),
//       ),
//     );
//   }
// }
