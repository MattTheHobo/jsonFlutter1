import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'entities/Drink.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Drink> _drinks = [];

  Future<List<Drink>> fetchNotes() async {
    var url =
        Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a');
    var response = await http.get(url);

    List<Drink> drinks = [];

    if (response.statusCode == 200) {
      var drinkJsonObj = json.decode(response.body)['drinks'] as List;

      drinks = drinkJsonObj
          .map((drinkJsonObj) => Drink.fromJson(drinkJsonObj))
          .toList();
      /*for (var noteJson in notesJson) {
        notes.add(Note.fromJson(noteJson));
      }*/
    }

    return drinks;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _drinks.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _drinks[index].name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _drinks[index].glass,
                    style: TextStyle(color: Colors.grey.shade700),
                  )
                ],
              ),
            ));
          },
          itemCount: _drinks.length,
        ));
  }
}
