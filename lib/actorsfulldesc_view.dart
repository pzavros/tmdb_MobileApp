import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'fulldesc_view.dart';
import 'modified_text.dart';

class actorsfulldesc_view extends StatefulWidget {
  final String title, picture;
  final id;
  final List known;
  const actorsfulldesc_view({Key? key, required this.title, required this.picture, this.id, required this.known}) : super(key: key);

  @override
  State<actorsfulldesc_view> createState() => _actorsfulldesc_view();
}
class _actorsfulldesc_view extends State<actorsfulldesc_view> {
  final String ApiKey = "0e2ff8013aa494a9e156ecc747006ff0";
  final String ApiToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTJmZjgwMTNhYTQ5NGE5ZTE1NmVjYzc0NzAwNmZmMCIsInN1YiI6IjYzOTk4YTUwNzdjMDFmMDBjYTVjODQxMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.YXTd7pOxyq_e7h-Q-OprHMoG5jjlwLg3E2OVLpIMFDc";

  Future<Map> _loadApi() async {
    TMDB tmdb = TMDB(ApiKeys(ApiKey, ApiToken));
    const ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    );
    Map actorResult = await tmdb.v3.people.getDetails(widget.id);
    return actorResult;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _loadApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Map actorDet = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Container(
                  padding: EdgeInsets.all(10),
                  child: modified_text(
                    text: widget.title,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              backgroundColor: Colors.black,
              body:
              SingleChildScrollView(
                  child:
                  Column(
                    children: [
                      Container(
                          height: 250,
                          child: Stack(children: [
                            Positioned(
                              child: Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  'http://image.tmdb.org/t/p/w500' +
                                      widget.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ])),
                      SizedBox(height: 15),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: modified_text(
                            text: 'Born: ' +
                                (actorDet['birthday'] ?? 'loading'),
                            size: 14,
                            color: Colors.white,
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          padding: EdgeInsets.only(left: 10),
                          child: modified_text(
                            text: 'Biography: ' +
                                (actorDet['biography'] ?? 'loading'),
                            size: 14,
                            color: Colors.white,
                          )),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          modified_text(
                            text: "Played on",
                            color: Colors.white,
                            size: 26,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                            height: 270,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.known.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => fullDesc_view(
                                              itemDesc: widget.known[index])),
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
                                                          widget.known[index]['poster_path']))),
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
                  )

              ),
            );
          } else {
            return Text("Error while fetching actor details");
          }
        } else {
          return const CupertinoActivityIndicator();

        }
      },
    );
  }
}
