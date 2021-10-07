import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Album> futureAlbum;
  String titleText = 'https://haveibeenpwned.com/api/v3/breachedaccount/';
  TextEditingController titleController = TextEditingController();
  void _setText() {
    setState(() {
      titleText = titleText + titleController.text;
    });
    print(titleText);
    fetch();
    //futureAlbum = fetch();
    //initState();
  }

  Future<Album> fetch() async {
    final response = await http.get(Uri.parse(titleText));

    if (response.statusCode == 200) {
      print(response.body);
      return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  /*@override
  void initState() {
    super.initState();
    //futureAlbum = fetch();
  }*/

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 60.0),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: const Text(
                    "Enter your email: ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: 1, fontSize: 35.0, color: Colors.blue),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      child: Text(
                        'Find!',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      onPressed: _setText,
                      //Show the text of breached data
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: FutureBuilder<Album>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data!.Domain);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    )),
              ],
            ))));
  }
}

class Album {
  final String Name;
  final String Title;
  final String Domain;

  Album({
    required this.Name,
    required this.Title,
    required this.Domain,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      Name: json['Name'],
      Title: json['Title'],
      Domain: json['Domain'],
    );
  }
}
