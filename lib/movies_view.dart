import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdbapp/modified_text.dart';
import 'main.dart';

class movies extends StatefulWidget {
  const movies({Key? key}) : super(key: key);

  @override
  State<movies> createState() => _moviesState();
}

class _moviesState extends State<movies> {
  final String ApiKey= "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
  List popMovies = [];

  loadApi () async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map popularResult = await tmdb.v3.movies.getNowPlaying();
    Map result2 = await tmdb.v3.search.queryMovies("");
    popMovies = popularResult["results"];

    setState(() {
      popMovies = popularResult['results'];
    });
    // print(popMovies[0]["original_title"]);

  }

  
  @override
  void initState() {
    super.initState();
    loadApi();
  }
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  modified_text(text: "Trending Movies", color: Colors.white,size: 26,),
                  Container(height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: popMovies.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){


                          },
                          child: Container(
                            width: 140,
                            child: Column(
                              children: [
                                Container(
                                  height : 200,
                                  decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(
                                    'http://image.tmdb.org/t/p/w500'+popMovies[index]['poster_path']
                                  ))),

                                ),
                                Container(
                                  child: modified_text(text: popMovies[index]['title']!=null? popMovies[index]['title']:'loading', color: Colors.white, size: 15),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )


        )


    );
  }

}
