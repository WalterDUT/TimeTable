
import 'package:flutter_calendar/MainPage.dart';
import 'package:flutter_calendar/model/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/res/event_firestore_service.dart';


class UpdateEventPage extends StatefulWidget {
  final EventModel note;

  const UpdateEventPage({Key key, this.note}) : super(key: key);

  @override
  _UpdateEventPageState createState() => _UpdateEventPageState();
}

class _UpdateEventPageState extends State<UpdateEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;
  TimeOfDay _beginTime;
  TimeOfDay _endTime;
  
  

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note != null ? widget.note.title : "");
    _description = TextEditingController(text:  widget.note != null ? widget.note.description : "");
    _eventDate = DateTime.now();
    _beginTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();
    
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
                title: Text("Begin Time: " + "${widget.note.beginTime.substring(10, 15)}"),
                subtitle: Text("Change"),
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
                title: Text("End Time: " + "${widget.note.endTime.substring(10, 15)}"),
                subtitle: Text("Change"),
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
                              if(widget.note != null) {
                                await eventDBS.updateData(widget.note.id,{
                                  "title": _title.text,
                                  "description": _description.text,
                                  "begin_time": _beginTime.toString(),
                                  "end_time": _endTime.toString()
                                  //"event_date": widget.note.eventDate
                                });
                              }else{
                                await eventDBS.createItem(EventModel(
                                  title: _title.text,
                                  description: _description.text,
                                  eventDate: _eventDate
                                ));
                              }
                              Navigator.pop(context);
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                          child: Text(
                            "Update",
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
                         showDialog(
                           context: context, 
                           builder: (_) => AlertDialog(
                               title: Text("Delete event"+_title.text),
                               content: Text("Are you sure you want to delete this event?"),
                               actions: [
                                 // ignore: deprecated_member_use
                                 //FlatButton(
                                  //onPressed: () {
                                   // Navigator.pop(context);
                                  //},
                                  //child: Text("Cancel"),
                                  //),
                                  
                                  // ignore: deprecated_member_use
                                  FlatButton(
                                  onPressed: () async {
                                    setState(() {
                                processing = true;
                              });
                                await eventDBS.removeItem(widget.note.id);
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp1()));  
                                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => MyApp1()));

                                setState(() {
                                processing = false;
                              });
                                },
                                  child: Text("Delete"),
                                  )
                               ],
                             )                            
                         );
                         },
                          child: Text(
                            "Delete",
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