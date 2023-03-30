import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdbapp/modified_text.dart';
import 'package:shake/shake.dart';
import 'package:tmdbapp/search_view.dart';

import 'main.dart';
class favorites extends StatefulWidget {
  const favorites({Key? key}) : super(key: key);

  @override
  State<favorites> createState() => _favoritesState();
}

class _favoritesState extends State<favorites> {
  Query dbRef = FirebaseDatabase.instance.ref().child('favorites');
  DatabaseReference reference = FirebaseDatabase.instance.ref().child('favorites');
  DatabaseReference ref = FirebaseDatabase.instance.ref("favorites");

  List<Map<String, dynamic>> favoriteItems = [];
  List<String> favoritePaths = [];

  @override

  void initState() {
    super.initState();
    activateListeners();
    // ...
  }

  void activateListeners() {
    dbRef.onValue.listen((event) {
      List<Map<String, dynamic>> items = [];
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          favoritePaths.add(key);
          final String? title = value['title'] as String?;
          final String? image = value['image'] as String?;
          final int? id = value['id'] as int?;
          final bool? isFavorite = value['isFavorite'] as bool?;
          final item = {'title': title, 'image': image, 'id': id, 'isFavorite': isFavorite};
          items.add(item);
        });
      }
      setState(() {
        favoriteItems = items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: favoriteItems.isEmpty ? _buildEmptyMessage() : _buildFavoritesList(),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your favorite list is empty!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mainWidget()),
              );
            },
            child: Text(
              'Discover',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildFavoritesList() {
    return ListView.builder(
      itemCount: favoriteItems.length,
      itemBuilder: (BuildContext context, int index) {
        final item = favoriteItems[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Image.network(
                'http://image.tmdb.org/t/p/w500' + item['image'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  modified_text(
                    text: item['title'],
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(height: 8),
                  IconButton(
                    icon: Icon(
                      item['isFavorite']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      reference.child('/${favoritePaths[index]}').remove().then((value) {
                        print('done');
                        setState(() {
                          favoritePaths.removeAt(index);
                        });
                      });
                    },
                  ),


                ],
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    dbRef.onValue.listen((event) {}).cancel();
    super.dispose();
  }

}
