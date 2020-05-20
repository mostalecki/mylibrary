import 'package:flutter/material.dart';
import 'package:mylibrary/models/game.dart';
import 'package:mylibrary/services/database.dart';

class AddGame extends StatefulWidget {

  GlobalKey<ScaffoldState> snackKey;
  bool editMode;
  Game game;

  AddGame({this.snackKey, this.editMode, this.game});

  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {

  DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String _dropdownPlatform = "PC";
  String title = '';
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.editMode ? Text('Edit game') : Text('Add game'),
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (val) => val.isNotEmpty ? null : 'Title cannot be empty.',
              initialValue: title,
              onChanged: (val){
                setState(() => title = val);
              },
              decoration: InputDecoration(
                hintText: 'Title'
              ),
            ),
            DropdownButton<String>(
              value: _dropdownPlatform,
              onChanged: (String newValue) {
                setState(() {
                  _dropdownPlatform = newValue;
                });
              },
              items: <String>['PC', 'PS4', 'XONE', 'Switch', 'Other']
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            CheckboxListTile(
              title: Text('Finished:'),
              value: finished,
              onChanged: (bool newValue) {
                setState(() {
                  finished = newValue;
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
              await _db.deleteGame(widget.game);
              Navigator.pop(context);
              widget.snackKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text('Game deleted'),
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
              Game _game = Game(title, _dropdownPlatform, finished: finished);
              if (!widget.editMode) {
                await _db.addGame(_game);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Game added'),
                    )
                );
              } else{
                _game.key = widget.game.key;
                await _db.editGame(_game);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Game edited'),
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
    if (widget.game != null){
      Game _game = widget.game;
      _dropdownPlatform = _game.platform;
      title = _game.title;
      finished = _game.finished;
    }
    super.initState();
  }
}
