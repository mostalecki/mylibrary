import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:mylibrary/screens/home/game_card.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:mylibrary/models/game.dart';

class GameList extends StatefulWidget {

  final GlobalKey<ScaffoldState> snackKey;

  GameList({this.snackKey,});

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final user = AuthService().currentUser;
  String _mode = 'All';
  Query _gameQuery;

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
                query: _gameQuery,
                key: ValueKey(_gameQuery),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index){
                  Game _game = Game.fromSnapshot(snapshot);
                  return GameCard(snackKey: widget.snackKey ,game: _game);
                }
            ),
          )
        ],
      )
    );
  }

  @override
  void initState() {
      _gameQuery = _db.reference().child('db').child(user.uid)
          .child('games')
          .orderByKey();
    super.initState();
  }

  changeQuery(String mode){
    setState(() {
    switch(mode){
      case 'All':
        _gameQuery = _db.reference().child('db').child(user.uid)
            .child('games')
            .orderByKey();
        break;
      case 'Unfinished':
        _gameQuery = _db.reference().child('db').child(user.uid)
            .child('games')
            .orderByChild('finished').equalTo(false);
        break;
      case 'Finished':
        _gameQuery = _db.reference().child('db').child(user.uid)
            .child('games')
            .orderByChild('finished').equalTo(true);
        break;
    }
    });
  }

  /*searchQuery(String query){
    setState(() {
      _gameQuery = _db.reference().child('db').child(user.uid)
          .child('games').orderByChild('title').
    });
  }*/
}
