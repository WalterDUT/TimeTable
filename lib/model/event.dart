import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem{
  final String id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String beginTime;
  final String endTime;
  final String userUid;
  

  EventModel({this.id,this.title, this.description, this.eventDate, this.beginTime, this.endTime, this.userUid}):super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'],
      beginTime: data['begin_time'],
      endTime: data['end_time'],
      userUid: data['user_uid']
    );
  }

  factory EventModel.fromDS(String id, Map<String,dynamic> data) {
    return EventModel(
      id: id,
      title: data['title'],
      description: data['description'],
      eventDate: data['event_date'].toDate(),
      beginTime: data['begin_time'],
      endTime: data['end_time'],
      userUid: data['user_uid']
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "title":title,
      "description": description,
      "event_date":eventDate,
      "id":id,
      "begin_time":beginTime,
      "end_time":endTime,
      "user_uid":userUid
    };
  }

  static collection(String s) {}
}