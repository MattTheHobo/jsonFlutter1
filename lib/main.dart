import 'package:cached_network_image/cached_network_image.dart';
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
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate(_drinks));
                },
                icon: Icon(Icons.search))
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _drinks[index].urlImg,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 60,
                      backgroundImage: imageProvider,
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Text(
                    _drinks[index].name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ));
          },
          itemCount: _drinks.length,
        ));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Drink> _cocktails;

  CustomSearchDelegate(this._cocktails);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Drink> drinkQuery = [];
    for (int i = 0; i < _cocktails.length; i++) {
      if (_cocktails[i].name.toLowerCase().contains(query.toLowerCase())) {
        drinkQuery.add(_cocktails[i]);
      }
    }

    return ListView.builder(
      itemCount: drinkQuery.length,
      itemBuilder: (context, index) {
        var result = drinkQuery[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Drink> drinkQuery = [];
    for (int i = 0; i < _cocktails.length; i++) {
      if (_cocktails[i].name.toLowerCase().contains(query.toLowerCase())) {
        drinkQuery.add(_cocktails[i]);
      }
    }

    return ListView.builder(
      itemCount: drinkQuery.length,
      itemBuilder: (context, index) {
        var result = drinkQuery[index];
        return ListTile(
          title: Text(result.name),
        );
      },
    );
  }
}
