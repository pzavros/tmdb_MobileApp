import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'modified_text.dart';

class tvfulldesc extends StatefulWidget {
  final Map<String, dynamic> itemDesc;
  const tvfulldesc({Key? key, required this.itemDesc}) : super(key: key);

  @override
  State<tvfulldesc> createState() => _tvfulldescState();
}

class _tvfulldescState extends State<tvfulldesc> {
  final database = FirebaseDatabase.instance.reference();

  late bool isFav = database.child('/favorites/isFavorite') as bool;

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Database and enable offline persistence
    Firebase.initializeApp().then((value) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      database.keepSynced(true);
    });
  }
  Widget build(BuildContext context) {
    final favRef = database.child('/favorites');
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,),

      backgroundColor: Colors.black,
      body: Container(
        child: ListView(children: [
          Container(
              height: 250,
              child: Stack(children: [
                Positioned(
                  child: Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      'http://image.tmdb.org/t/p/w500' +
                          widget.itemDesc['backdrop_path'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 10,
                    child: modified_text(
                      text: '⭐ Average Rating - ' +
                          (widget.itemDesc['vote_average']?.toString() ??
                              'loading'),
                      color: Colors.white,
                      size: 20,
                    )),
              ])),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(10),
            child: modified_text(
              text: widget.itemDesc['name'] ?? 'loading',
              color: Colors.white,
              size: 26,
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: modified_text(
                text: 'Released On - ' +
                    (widget.itemDesc['first_air_date'] ?? 'loading'),
                size: 14,
                color: Colors.white,
              )),
          ElevatedButton(
            onPressed: () {
              favRef.push().set({
                'title': widget.itemDesc['name'],
                'image': 'http://image.tmdb.org/t/p/w500' + widget.itemDesc['poster_path'],
                'id': widget.itemDesc['id'],
                'isFavorite': true
              });

              final snackBar = SnackBar(
                content: const Text('Added to favorites!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              elevation: 5.0,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 8.0),
                Text('Favorites', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),


          // Container(
          //   height: 200,
          //   width: 100,
          //   child: Image.network('http://image.tmdb.org/t/p/w500' +
          //       widget.itemDesc['backdrop_path']),
          // ),
          Flexible(
            child: Container(
                padding: EdgeInsets.all(10),
                child: modified_text(
                  text: widget.itemDesc['overview'] != null
                      ? widget.itemDesc['overview']
                      : 'loading',
                  size: 18,
                  color: Colors.white,
                )),

          )
        ]),
      ),
    );
  }
}
