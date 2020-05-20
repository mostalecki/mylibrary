import 'package:flutter/material.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/services/database.dart';

class AddBook extends StatefulWidget {

  GlobalKey<ScaffoldState> snackKey;
  bool editMode;
  Book book;

  AddBook({this.snackKey, this.editMode, this.book});

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  String author = '';
  String title = '';
  bool finished = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.editMode ? Text('Edit book') : Text('Add book'),
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
            TextFormField(
              validator: (val) => val.isNotEmpty ? null : 'Author cannot be empty.',
              initialValue: author,
              onChanged: (val){
                setState(() => author = val);
              },
              decoration: InputDecoration(
                  hintText: 'Author'
              ),
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
                await _db.deleteBook(widget.book);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Book deleted'),
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
              Book _book = Book(title, author, finished: finished);
              if (!widget.editMode) {
                await _db.addBook(_book);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Book added'),
                    )
                );
              } else{
                _book.key = widget.book.key;
                await _db.editBook(_book);
                Navigator.pop(context);
                widget.snackKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text('Book edited'),
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
    if (widget.book != null){
      Book _book = widget.book;
      author = _book.author;
      title = _book.title;
      finished = _book.finished;
    }
    super.initState();
  }
}
