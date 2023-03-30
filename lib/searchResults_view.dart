import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:tmdbapp/tvfulldesc_view.dart';

import 'actorsfulldesc_view.dart';
import 'fulldesc_view.dart';
import 'modified_text.dart';

class searchResults_view extends StatefulWidget {
   final String? searchtext;
   const searchResults_view({Key? key,required this.searchtext }) : super(key: key);

  @override
  State<searchResults_view> createState() => _searchResults_viewState();
}

class _searchResults_viewState extends State<searchResults_view> {

  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";
List searchList = [];
List tvsearchList = [];
List actorssearchList = [];
  loadApi() async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map searchResult = await tmdb.v3.search.queryMovies(widget.searchtext!);
    Map tvsearchResult = await tmdb.v3.search.queryTvShows(widget.searchtext!);
    Map actorssearchResult = await tmdb.v3.search.queryPeople(widget.searchtext!);

    setState(() {
      searchList = searchResult['results'];
      tvsearchList = tvsearchResult['results'];
      actorssearchList = actorssearchResult['results'];
    });

  }

  @override
  void initState() {
    super.initState();
    loadApi();
  }
  @override

  Widget build(BuildContext context) {


    return  Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('You search for: ${widget.searchtext}'),
      ),
      body:
      ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const modified_text(
                text: "Movies",
                color: Colors.white,
                size: 26,
              ),
              Container(
                height: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    if (searchList[index]['poster_path'] == null) {
                      return Container();
                    } else {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => fullDesc_view(
                                    itemDesc: searchList[index])),
                          );
                        },
                        child: Container(
                          width: 200,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 300,
                                    child: AspectRatio(
                                      aspectRatio: 0.7,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: (searchList[index]['poster_path'] != null)
                                            ? Image.network(
                                          'https://image.tmdb.org/t/p/w500/${searchList[index]['poster_path']}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text('Error loading image'),
                                            );
                                          },
                                        )
                                            : Center(
                                          child: Text('No image available'),
                                        ),
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
                                          '${searchList[index]['vote_average'] ?? 'Not found'}',
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
                              Container(
                                child: modified_text(text: searchList[index]['title'], color: Colors.white, size: 20),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
          //tv shows search result
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              modified_text(
                text: "TV Shows",
                color: Colors.white,
                size: 26,
              ),
              SizedBox(height: 10),
              Container(
                height: 400,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tvsearchList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => tvfulldesc(
                                itemDesc: tvsearchList[index]
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 200,
                        child: Column(
                          children: [
                            Visibility(
                              visible: tvsearchList[index]['poster_path'] != null,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 300,
                                        child: AspectRatio(
                                          aspectRatio: 0.7,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.network(
                                              'http://image.tmdb.org/t/p/w500' +
                                                  (tvsearchList[index]['poster_path'] ?? 'Not found'),
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Center(
                                                  child: Text('Error loading image'),
                                                );
                                              },
                                            ),
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
                                              '${tvsearchList[index]['vote_average'] ?? 'not found'}',
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
                                  Container(
                                    child: modified_text(text: tvsearchList[index]['name'], color: Colors.white, size: 18),
                                  ),
                                ],
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

          //Actors search results
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
                  itemCount: actorssearchList.length,
                  itemBuilder: (context, index) {
                    if (actorssearchList[index]['profile_path'] == null) {
                      // Skip the item if the profile_path is null
                      return SizedBox.shrink();
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => actorsfulldesc_view(
                              picture: actorssearchList[index]['profile_path'],
                              title: actorssearchList[index]['name'],
                              known: actorssearchList[index]['known_for'],
                              id: actorssearchList[index]['id'],
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
                                child: AspectRatio(
                                  aspectRatio: 0.7,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500/${actorssearchList[index]['profile_path']}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Text('Error loading image'),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: modified_text(
                                text: actorssearchList[index]['name'] ?? 'loading',
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
