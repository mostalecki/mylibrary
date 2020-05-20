import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mylibrary/models/movie.dart';
import 'package:mylibrary/services/auth.dart';

import 'movie_card.dart';

class MovieList extends StatefulWidget{

  final GlobalKey<ScaffoldState> snackKey;

  MovieList({this.snackKey,});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final user = AuthService().currentUser;
  String _mode = 'All';
  Query _movieQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment:MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                DropdownButton<String>(
                  value: _mode,
                  onChanged: (String newValue) {
                    setState(() {
                      _mode = newValue;
                      changeQuery(newValue);
                    });
                  },
                  items: <String>['All', 'Finished', 'Unfinished']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child:Text(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            Expanded(
              child: FirebaseAnimatedList(
                  query: _movieQuery,
                  key: ValueKey(_movieQuery),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index){
                    Movie _movie = Movie.fromSnapshot(snapshot);
                    return MovieCard(snackKey: widget.snackKey ,movie: _movie);
                  }
              ),
            )
          ],
        )
    );
  }

  @override
  void initState() {
    _movieQuery = _db.reference().child('db').child(user.uid)
        .child('movies')
        .orderByKey();
    super.initState();
  }

  changeQuery(String mode) {
    setState(() {
      switch (mode) {
        case 'All':
          _movieQuery = _db.reference().child('db').child(user.uid)
              .child('movies')
              .orderByKey();
          break;
        case 'Unfinished':
          _movieQuery = _db.reference().child('db').child(user.uid)
              .child('movies')
              .orderByChild('finished').equalTo(false);
          break;
        case 'Finished':
          _movieQuery = _db.reference().child('db').child(user.uid)
              .child('movies')
              .orderByChild('finished').equalTo(true);
          break;
      }
    });
  }
}
