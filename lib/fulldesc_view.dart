import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdbapp/modified_text.dart';

class fullDesc_view extends StatefulWidget {
  final Map<String, dynamic> itemDesc;
  fullDesc_view({Key? key, required this.itemDesc}) : super(key: key);

  @override
  State<fullDesc_view> createState() => _fullDesc_viewState();
}

class _fullDesc_viewState extends State<fullDesc_view> {
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

  @override
  Widget build(BuildContext context) {
    final favRef = database.child('/favorites');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
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
              text: widget.itemDesc['title'] ?? 'loading',
              color: Colors.white,
              size: 26,
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: modified_text(
                text: 'Released On - ' +
                    (widget.itemDesc['release_date'] ?? 'loading'),
                size: 14,
                color: Colors.white,
              )),
          Container(
              padding: EdgeInsets.only(left: 10),
              child: modified_text(
                text: 'Genres' + (widget.itemDesc['release_date'] ?? 'loading'),
                size: 14,
                color: Colors.white,
              )),
          ElevatedButton(
            onPressed: () {
              final movieId = widget.itemDesc['id'].toString(); // get the movie ID as a string
              favRef.child(movieId).set({ // use the movie ID as the key instead of push()
                'title': widget.itemDesc['title'],
                'image': 'http://image.tmdb.org/t/p/w500' + widget.itemDesc['poster_path'],
                'id' : widget.itemDesc['id'],
                'isFavorite': true
              });

              final snackBar = SnackBar(
                content: const Text('Added to favorites!'),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },

            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              elevation: 8,
            ),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Favorites',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
             Container(
                padding: EdgeInsets.all(10),
                child: modified_text(
                  text: widget.itemDesc['overview'] != null
                      ? widget.itemDesc['overview']
                      : 'loading',
                  size: 18,
                  color: Colors.white,
                )),

        ]),
      ),
    );

  }

}
