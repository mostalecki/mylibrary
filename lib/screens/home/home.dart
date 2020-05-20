import 'package:flutter/material.dart';
import 'package:mylibrary/models/user.dart';
import 'package:mylibrary/screens/home/book_list.dart';
import 'package:mylibrary/screens/home/formDialogs/add_book.dart';
import 'package:mylibrary/screens/home/formDialogs/add_game.dart';
import 'package:mylibrary/screens/home/formDialogs/add_movie.dart';
import 'package:mylibrary/screens/home/formDialogs/add_tvshow.dart';
import 'package:mylibrary/screens/home/game_list.dart';
import 'package:mylibrary/screens/home/movie_list.dart';
import 'package:mylibrary/screens/home/tvshow_list.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:mylibrary/services/database.dart';

class Home extends StatefulWidget {

  User currentUser;

  Home({this.currentUser});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final snackKey = GlobalKey<ScaffoldState>();
  DatabaseService _db = DatabaseService();

  GameList _gameList;
  BookList _bookList;
  MovieList _movieList;
  TvShowList _tvShowList;


  int _index = 0;

  static List<String> choices = const <String> [
    'All', 'Unfinished', 'Finished'
  ];

  String choice = choices[0];

  createAlertDialog(BuildContext context, int tabIndex) {

    return showDialog(context: context, builder: (context){
      return getForm(tabIndex);
    });
  }
  
  getForm(int tabIndex){
    switch(tabIndex){
      case 0:
        return AddGame(snackKey: snackKey, editMode: false,);
        break;
      case 1:
        return AddBook(snackKey: snackKey, editMode: false,);
        break;
      case 2:
        return AddMovie(snackKey: snackKey, editMode: false,);
        break;
      case 3:
        return AddTvShow(snackKey: snackKey, editMode: false,);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          key: snackKey,
          //backgroundColor: Colors.blueGrey[700],
          appBar: AppBar(
            title: Text('MyLibrary'),
            backgroundColor: Colors.orange[600],
            bottom: TabBar(
                onTap: (index) {
                  setState(() => _index = index);
                },
                tabs: [
                  Tab(icon: Icon(Icons.videogame_asset)),
                  Tab(icon: Icon(Icons.book)),
                  Tab(icon: Icon(Icons.local_movies)),
                  Tab(icon: Icon(Icons.tv))
                ]),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text(widget.currentUser.email),
                  decoration: BoxDecoration(color: Colors.orange[600]),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Account'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () async {
                    await _auth.signOut();
                  },
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              _gameList,
              _bookList,
              _movieList,
              _tvShowList
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.orange[800],
            onPressed: () async {
              createAlertDialog(context, _index);
            },
          ),
        )
    );
  }

  @override
  void initState() {
_auth.currentUser = widget.currentUser;
_gameList = GameList(snackKey: snackKey);
_bookList = BookList(snackKey: snackKey,);
_movieList = MovieList(snackKey: snackKey,);
_tvShowList = TvShowList(snackKey: snackKey,);
super.initState();
}
}
