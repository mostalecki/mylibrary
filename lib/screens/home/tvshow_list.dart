import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mylibrary/models/movie.dart';
import 'package:mylibrary/screens/home/tvshow_card.dart';
import 'package:mylibrary/services/auth.dart';

import 'movie_card.dart';

class TvShowList extends StatefulWidget {

  final GlobalKey<ScaffoldState> snackKey;

  TvShowList({this.snackKey,});

  @override
  _TvShowListState createState() => _TvShowListState();
}

class _TvShowListState extends State<TvShowList> {

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final user = AuthService().currentUser;
  String _mode = 'All';
  Query _tvshowQuery;

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
                  query: _tvshowQuery,
                  key: ValueKey(_tvshowQuery),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index){
                    Movie _movie = Movie.fromSnapshot(snapshot);
                    return TvShowCard(snackKey: widget.snackKey ,movie: _movie);
                  }
              ),
            )
          ],
        )
    );
  }

  @override
  void initState() {
    _tvshowQuery = _db.reference().child('db').child(user.uid)
        .child('tvshows')
        .orderByKey();
    super.initState();
  }

  changeQuery(String mode) {
    setState(() {
      switch (mode) {
        case 'All':
          _tvshowQuery = _db.reference().child('db').child(user.uid)
              .child('tvshows')
              .orderByKey();
          break;
        case 'Unfinished':
          _tvshowQuery = _db.reference().child('db').child(user.uid)
              .child('tvshows')
              .orderByChild('finished').equalTo(false);
          break;
        case 'Finished':
          _tvshowQuery = _db.reference().child('db').child(user.uid)
              .child('tvshows')
              .orderByChild('finished').equalTo(true);
          break;
      }
    });
  }
}
