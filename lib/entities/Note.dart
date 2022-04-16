import 'dart:convert';

class Note {
  String title;
  String body;

  Note(this.title, this.body);

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['text'];
}
