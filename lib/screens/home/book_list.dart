import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/screens/home/book_card.dart';
import 'package:mylibrary/services/auth.dart';

class BookList extends StatefulWidget {

  final GlobalKey<ScaffoldState> snackKey;

  BookList({this.snackKey,});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  final user = AuthService().currentUser;
  String _mode = 'All';
  Query _bookQuery;

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
                  query: _bookQuery,
                  key: ValueKey(_bookQuery),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index){
                    Book _book = Book.fromSnapshot(snapshot);
                    return BookCard(snackKey: widget.snackKey ,book: _book);
                  }
              ),
            )
          ],
        )
    );
  }

  @override
  void initState() {
    _bookQuery = _db.reference().child('db').child(user.uid)
        .child('books')
        .orderByKey();
    super.initState();
  }

  changeQuery(String mode){
    setState(() {
      switch(mode){
        case 'All':
          _bookQuery = _db.reference().child('db').child(user.uid)
              .child('books')
              .orderByKey();
          break;
        case 'Unfinished':
          _bookQuery = _db.reference().child('db').child(user.uid)
              .child('books')
              .orderByChild('finished').equalTo(false);
          break;
        case 'Finished':
          _bookQuery = _db.reference().child('db').child(user.uid)
              .child('books')
              .orderByChild('finished').equalTo(true);
          break;
      }
    });
  }
}
