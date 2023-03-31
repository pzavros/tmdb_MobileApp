import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tmdbapp/home_view.dart';
import 'package:tmdbapp/search_view.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'favorites_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const mainWidget());
}

class mainWidget extends StatelessWidget {
  const mainWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mainWidget_view();
  }
}

class mainWidget_view extends StatefulWidget {
  const mainWidget_view({Key? key}) : super(key: key);

  @override
  State<mainWidget_view> createState() => _mainWidget_viewState();
}

class _mainWidget_viewState extends State<mainWidget_view> {
  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
  List popMovies = [];
  List topratedMovies = [];

  loadApi() async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map popularResult = await tmdb.v3.movies.getPopular();
    Map topratedResult = await tmdb.v3.movies.getTopRated();

    setState(() {
      popMovies = popularResult['results'];
      topratedMovies = topratedResult['results'];
    });
  }

  int _currentIndex = 0;

  final List<Widget> _children = [
    home(),
    search(),
    favorites(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final Future<FirebaseApp> db = Firebase.initializeApp();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.cyanAccent, // color of selected item
          unselectedItemColor: Colors.grey, // color of unselected items

          showUnselectedLabels: true,
          backgroundColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }
}
