import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdbapp/modified_text.dart';
import 'package:shake/shake.dart';

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
  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
  List favoritesList = [];

  @override
  void initState() {
    super.initState();
    activateListeners();
    ShakeDetector detector= ShakeDetector.autoStart(onPhoneShake: () {
      setState(() {
        favoriteItems.shuffle();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shuffled!'),
        ),
      );
    },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
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
        setState(() {
          favoriteItems = items;
        });
        //dispose
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (BuildContext context, int index) {
          final item = favoriteItems[index];
          if (favoriteItems != null) {
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
                          //await ref.remove();
                          //reference.child(item[index]).remove();
                          // TODO: implement favorite button functionality
                          // Remove the item from the database
                           reference.child('/${favoritePaths[index]}').remove().then((value) {
                             print('done');
                           });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Text('Empty')
              ],
            );
          }
        },
      ),

    );
  }
}
