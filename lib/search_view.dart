import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdbapp/actorsfulldesc_view.dart';
import 'package:tmdbapp/searchResults_view.dart';
import 'package:tmdbapp/tvfulldesc_view.dart';
import 'fulldesc_view.dart';
import 'modified_text.dart';

class search extends StatefulWidget {
  const search({Key? key}) : super(key: key);

  @override
  State<search> createState() => _search_viewState();
}

class _search_viewState extends State<search> {
  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
  List popMovies = [];
  List topratedMovies = [];
  List popActors = [];
  List top5tv = [];
  List top5movies = [];
  late String usersInput;
  final TextEditingController _textController = TextEditingController();

  loadApi() async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map popularResult = await tmdb.v3.movies.getPopular();
    Map topratedResult = await tmdb.v3.movies.getNowPlaying();
    Map top5tvResults = await tmdb.v3.tv.getTopRated();
    Map top5moviesResults = await tmdb.v3.movies.getTopRated();
    Map actorsResult = await tmdb.v3.people.getPopular();
    Map searchResult = await tmdb.v3.search.queryMovies(_textController.text);

    //print(actorsResult);

    setState(() {
      popMovies = popularResult['results'];
      topratedMovies = topratedResult['results'];
      popActors = actorsResult['results'];
      top5tv = top5tvResults['results'];
      top5movies = top5moviesResults['results'];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  void initState() {
    super.initState();
    loadApi();
    usersInput = '';
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (searchText) {
                  if (searchText.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            searchResults_view(searchtext: searchText),
                      ),
                    );
                  }
                }),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_textController.text.length >= 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => searchResults_view(
                              searchtext: _textController.text)),
                    );
                  } else {}
                  //print('Search for: $usersInput');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  backgroundColor:
                      Colors.black, // Text Color (Foreground color)
                ),
                child: Icon(Icons.search),
              )
            ],
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  //Display Popular today
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modified_text(
                        text: "Popular Today",
                        color: Colors.white,
                        size: 26,
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popMovies.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => fullDesc_view(
                                          itemDesc: popMovies[index])),
                                );
                              },
                              child: Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://image.tmdb.org/t/p/w500' +
                                                      popMovies[index]
                                                          ['poster_path']))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  //Display now playing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modified_text(
                        text: "Now Playing",
                        color: Colors.white,
                        size: 26,
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: topratedMovies.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => fullDesc_view(
                                          itemDesc: topratedMovies[index])),
                                );
                              },
                              child: Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://image.tmdb.org/t/p/w500' +
                                                      topratedMovies[index]
                                                          ['poster_path']))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  //Display top 5 tv shows
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modified_text(
                        text: "Top 5 TV Shows",
                        color: Colors.white,
                        size: 26,
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: top5tv.length >= 5 ? 5 : top5tv.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => tvfulldesc(
                                          itemDesc: top5tv[index])),
                                );
                              },
                              child: Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://image.tmdb.org/t/p/w500' +
                                                      top5tv[index]
                                                      ['poster_path']))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  //Display top 5 movies
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modified_text(
                        text: "Top 5 Movies",
                        color: Colors.white,
                        size: 26,
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: top5movies.length >= 5 ? 5 : top5movies.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => fullDesc_view(
                                          itemDesc: top5movies[index])),
                                );
                              },
                              child: Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'http://image.tmdb.org/t/p/w500' +
                                                      top5movies[index]
                                                      ['poster_path']))),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  //Display Actors
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      modified_text(
                        text: "Actors",
                        color: Colors.white,
                        size: 26,
                      ),
                      Container(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: popActors.length,
                          itemBuilder: (context, index) {
                            // Skip the actor if any of the required fields are null
                            if (popActors[index]['profile_path'] == null ||
                                popActors[index]['name'] == null ||
                                popActors[index]['known_for'] == null ||
                                popActors[index]['id'] == null) {
                              return SizedBox.shrink();
                            }

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => actorsfulldesc_view(
                                      picture: popActors[index]['profile_path'],
                                      title: popActors[index]['name'],
                                      known: popActors[index]['known_for'],
                                      id: popActors[index]['id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              'http://image.tmdb.org/t/p/w500' +
                                                  popActors[index]['profile_path'],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: modified_text(
                                        text: popActors[index]['name'] ?? 'loading',
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
