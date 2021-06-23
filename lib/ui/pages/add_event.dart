import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_calendar/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/res/event_firestore_service.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  TimeOfDay _beginTime;
  TimeOfDay _endTime;
  String _userUid;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
   final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    _beginTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
    User user = _auth.currentUser;
    _userUid = user.uid;
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "Edit Event" : "Add Event"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter title" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                      (value.isEmpty) ? "Please Enter description" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),

              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)"),
                subtitle: Text("${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}"),
                onTap: ()async{
                  DateTime picked = await showDatePicker(context: context, initialDate: _eventDate, firstDate: DateTime(_eventDate.year-5), lastDate: DateTime(_eventDate.year+5));
                  if(picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Begin Time"),
                subtitle: Text("${_beginTime.hour} : ${_beginTime.minute}"),
                onTap: ()async{
                  TimeOfDay picked = await showTimePicker(context: context, initialTime: _beginTime);
                   if(picked != null) {
                    setState(() {
                      _beginTime = picked;
                    });
                  }
                },
              ),

              const SizedBox(height: 10.0),
              ListTile(
                title: Text("End Time"),
                subtitle: Text("${_endTime.hour} : ${_endTime.minute} "),
                onTap: ()async{
                  TimeOfDay picked = await showTimePicker(context: context, initialTime: _endTime);
                   if(picked != null) {
                    setState(() {
                      _endTime = picked;
                    });
                  }
                },
              ),

              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                        child: MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              //if(widget.note != null) {
                                //await eventDBS.updateData(widget.note.id,{
                                 // "title": _title.text,
                                 // "description": _description.text,
                                 // "event_date": widget.note.eventDate,
                                  //"begin_time": widget.note.beginTime,
                                  //"end_time": widget.note.endTime
                               // });
                             // }else{
                               

                                await eventDBS.createItem(EventModel(
                                  title: _title.text,
                                  description: _description.text,
                                  eventDate: _eventDate,
                                  beginTime: _beginTime.toString(),
                                  endTime: _endTime.toString(),
                                  userUid: _userUid
                                ));
                              //}
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Save",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}