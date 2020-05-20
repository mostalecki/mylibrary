import 'package:flutter/material.dart';
import 'package:mylibrary/models/game.dart';
import 'package:mylibrary/screens/home/formDialogs/add_game.dart';

class GameCard extends StatelessWidget {

  Game game;
  GlobalKey<ScaffoldState> snackKey;

  GameCard({this.game, this.snackKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: InkWell(
        onTap: (){
          showDialog(context: context, builder: (context){
            return AddGame(snackKey: snackKey, editMode: true, game: game,);
          });
        },
        child: ListTile(
          leading: Icon(Icons.videogame_asset),
          title: Text(game.title),
          subtitle: Text(game.platform),
          trailing: game.finished ? Icon(Icons.check_box) : null,
        ),
      )
    );
  }
}
