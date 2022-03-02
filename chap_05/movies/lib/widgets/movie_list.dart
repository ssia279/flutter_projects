import 'package:flutter/material.dart';
import 'package:movies/utils/http_helper.dart';

import '../models/movie.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {

  @override
  _MovieListState createState() {
    return _MovieListState();
  }

}

class _MovieListState extends State<MovieList> {
  late HttpHelper helper;
  List? movies;
  int? movieCount;

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage = 'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(title: searchBar,
      actions: [
        IconButton(onPressed: () {
          setState(() {
            if (visibleIcon.icon == Icons.search) {
              visibleIcon = Icon(Icons.cancel);
              searchBar = TextField(
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                onSubmitted: (String text) { search(text) ;},
              );
            } else {
              setState(() {
                visibleIcon = Icon(Icons.search);
                searchBar = Text('Movies');
              });
            }
          });
        }, icon: visibleIcon),
      ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int position) {
          if (movies![position].posterPath != null) {
            image = NetworkImage(iconBase + movies![position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(movies![position].title!),
              subtitle: Text('Released: ' + movies![position].releaseDate! + ' - Vote: ' +
              movies![position].voteAverage.toString()),
              leading: CircleAvatar(backgroundImage: image),
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (_) => MovieDetail(movies![position]));
                Navigator.push(context, route);
              },
            ),
          );
        },
        itemCount: (movieCount == null) ? 0 : movieCount,
      ),
    );
  }

  Future initialize() async {
    movies = [];
    movies = await helper.getUpcoming();
    setState(() {
      movieCount = movies?.length;
      movies = movies;
    });
  }

  Future search(String text) async {
    movies = await helper.findMovies(text);
    setState(() {
      movieCount = movies?.length;
      movies = movies;
    });
  }

}