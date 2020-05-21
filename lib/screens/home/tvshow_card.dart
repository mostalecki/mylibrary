import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mylibrary/models/movie.dart';
import 'package:mylibrary/screens/home/formDialogs/add_movie.dart';
import 'package:mylibrary/screens/home/formDialogs/add_tvshow.dart';

class TvShowCard extends StatelessWidget {

  Movie movie;
  GlobalKey<ScaffoldState> snackKey;

  TvShowCard({this.movie, this.snackKey});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: InkWell(
          onTap: (){
            showDialog(context: context, builder: (context){
              return AddTvShow(snackKey: snackKey, editMode: true, movie: movie,);
            });
          },
          child: Row(
            children: <Widget>[
              posterWidget(movie.posterUrl),
              Flexible(child:ListTile(
                //leading: posterWidget(movie.posterUrl),
                title: Text(movie.title),
                subtitle: Text(movie.year),
                trailing: movie.finished ? Icon(Icons.check_box) : null,
              ),
              )
            ],)
        /*child: Row(
          children: <Widget>[
            posterWidget(movie.posterUrl),
            Column(
              children: <Widget>[
                Text(movie.title),
                Text(movie.year)
              ],
            )
          ],
        ),*/
      ),
    );
  }

  posterWidget(String posterUrl){
    if(posterUrl != null){
      return Container(
        child:Image.network(posterUrl),
        height: 150,
        width: 100,
      );
    }
    return Container(
      child:Icon(Icons.local_movies),
      width: 100,
      height: 150,
      color: Colors.grey,
    );
  }
}
