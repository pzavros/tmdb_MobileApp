import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdbapp/tvfulldesc_view.dart';
import 'fulldesc_view.dart';
import 'main.dart';
import 'modified_text.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
  List popMovies = [];
  List topratedMovies = [];
  List upcomingMovies = [];
  List popShows = [];
  List topratedShows = [];
  //List latestShows = [];

  loadApi() async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map popularResult = await tmdb.v3.movies.getPopular();
    Map topratedResult = await tmdb.v3.movies.getTopRated();
    Map upcomingResult = await tmdb.v3.movies.getUpcoming();
    Map populartvResult = await tmdb.v3.tv.getPopular();
    Map topratedtvResult = await tmdb.v3.tv.getTopRated();
    // Map latesttvResult = await tmdb.v3.tv.getLatest();
    Map result2 = await tmdb.v3.search.queryMovies("");

    //print(populartvResult);
    // print(popMovies[0]["original_title"]);

    setState(() {
      popMovies = popularResult['results'];
      topratedMovies = topratedResult['results'];
      upcomingMovies = upcomingResult['results'];
      popShows = populartvResult['results'];
      topratedShows = topratedtvResult['results'];
      //latestShows = latesttvResult['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadApi();
    ShakeDetector detector = ShakeDetector.autoStart(
        onPhoneShake: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Shake!'),
        ),
      );
      // Do stuff on phone shake
    },
    minimumShakeCount: 1,
    shakeSlopTimeMS: 500,
    shakeCountResetTime: 3000,
    shakeThresholdGravity: 2.7,
    );

  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(

            backgroundColor: Colors.black,
            appBar: AppBar(
              toolbarHeight: 6,
              backgroundColor: Colors.black,
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.movie),
                    text: 'Movies',
                  ),
                  Tab(
                    icon: Icon(Icons.tv),
                    text: 'TV Shows',
                  ),
                ],
              ),
            ),
            body: TabBarView(

              children: [

                //display movies only
                ListView(

                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const modified_text(
                          text: "Trending Movies",
                          color: Colors.white,
                          size: 26,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
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
                                      Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://image.tmdb.org/t/p/w500' +
                                                        popMovies[index]
                                                            ['poster_path']),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '${popMovies[index]['vote_average']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modified_text(
                          text: "Top Rated",
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
                                      Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://image.tmdb.org/t/p/w500' +
                                                        topratedMovies[index]
                                                            ['poster_path']),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '${topratedMovies[index]['vote_average']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                    //Upcoming Movies
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modified_text(
                          text: "Upcoming Movies",
                          color: Colors.white,
                          size: 26,
                        ),
                        Container(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingMovies.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => fullDesc_view(
                                            itemDesc: upcomingMovies[index])),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://image.tmdb.org/t/p/w500' +
                                                        upcomingMovies[index]
                                                            ['poster_path']),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '${upcomingMovies[index]['vote_average']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  ],
                ),
                ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modified_text(
                          text: "Trending TV Shows",
                          color: Colors.white,
                          size: 26,
                        ),
                        Container(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: popShows.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => tvfulldesc(
                                            itemDesc: popShows[index])),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  child: Column(
                                    children: [
                                      if(popShows[index]['poster_path'] != null)
                                      Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://image.tmdb.org/t/p/w500' +
                                                        popShows[index]
                                                            ['poster_path']),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '${popShows[index]['vote_average']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modified_text(
                          text: "Top Rated TV Shows",
                          color: Colors.white,
                          size: 26,
                        ),
                        Container(
                          height: 270,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topratedShows.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => tvfulldesc(
                                            itemDesc: topratedShows[index])),
                                  );
                                },
                                child: Container(
                                  width: 140,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    'http://image.tmdb.org/t/p/w500' +
                                                        topratedShows[index]
                                                            ['poster_path']),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 10,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                Text(
                                                  '${topratedShows[index]['vote_average']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
