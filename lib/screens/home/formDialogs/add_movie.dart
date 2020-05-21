import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mylibrary/models/movie.dart';
import 'package:mylibrary/services/database.dart';
import 'package:mylibrary/services/movie_api.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddMovie extends StatefulWidget {

  GlobalKey<ScaffoldState> snackKey;
  bool editMode;
  Movie movie;

  AddMovie({this.snackKey, this.editMode, this.movie});

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {

  DatabaseService _db = DatabaseService();
  MovieApiService _api = MovieApiService();
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final yearController = TextEditingController();

  String _title = '';
  String _year = '';
  String _posterUrl;
  bool _finished = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.editMode ? Text('Edit movie') : Text('Add movie'),
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TypeAheadFormField(
              validator: (val) => val.isNotEmpty ? null : 'Title cannot be empty.',
              textFieldConfiguration: TextFieldConfiguration(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title'
                ),
              ),
              suggestionsCallback: (titlePattern) async {
                return await _api.fetchMovieSuggestions(titlePattern, type:'movie');
              },
              itemBuilder: (context, suggestion){
                return ListTile(
                  leading: Image.network(suggestion['Poster']),
                  title: Text(suggestion['Title']),
                  subtitle: Text(suggestion['Year']),
                );
              },
              onSuggestionSelected: (suggestion){
                print('Wybrano ${suggestion['Title']}');
                setState(() {
                  titleController.text = suggestion['Title'];
                  yearController.text = suggestion['Year'];
                  _title = suggestion['Title'];
                  _year = suggestion['Year'];
                  _posterUrl = suggestion['Poster'];
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: yearController,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (val){
                setState(() {
                  _year = val;
                });
              },
              decoration: InputDecoration(
                  hintText: 'Year'
              ),
            ),
            posterWidget(),
            CheckboxListTile(
              title: Text('Finished:'),
              value: _finished,
              onChanged: (bool newValue) {
                setState(() {
                  _finished = newValue;
                });
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
            child: widget.editMode ? Icon(Icons.delete) : null,
            onPressed: () async {
              if (widget.editMode){
                await _db.deleteMovie(widget.movie);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Movie deleted'),
                    )
                );
              }
            }
        ),
        SizedBox(width: 120.0,),
        MaterialButton(
          elevation: 5.0,
          child: Text('Submit'),
          onPressed: () async {
            if (_formKey.currentState.validate()){
              _title = titleController.text;
              Movie movie = Movie(title: _title, year:_year, posterUrl: _posterUrl, finished: _finished);
              if (!widget.editMode) {
                await _db.addMovie(movie);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Movie added'),
                    )
                );
              } else{
                movie.key = widget.movie.key;
                await _db.editMovie(movie);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Movie edited'),
                    )
                );
              }
            }
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    if (widget.movie != null){
      Movie _movie = widget.movie;
      _title = _movie.title;
      titleController.text = _title;
      _year = _movie.year;
      yearController.text = _year;
      _finished = _movie.finished;
      _posterUrl = _movie.posterUrl;
    }
    super.initState();
  }

  posterWidget(){
    if(_posterUrl != null){
      return Container(
          child:Image.network(_posterUrl),
        height: 150,
        width: 100,
        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      );
    }
    return Container(
        child:Icon(Icons.local_movies),
      width: 100,
      height: 150,
      color: Colors.grey,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
    );
  }
}
