import 'package:flutter/material.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/screens/home/formDialogs/add_book.dart';

class BookCard extends StatelessWidget {

  Book book;
  GlobalKey<ScaffoldState> snackKey;

  BookCard({this.book, this.snackKey});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[300],
        child: InkWell(
          onTap: (){
            showDialog(context: context, builder: (context){
              return AddBook(snackKey: snackKey, editMode: true, book: book,);
            });
          },
          child: ListTile(
            leading: Icon(Icons.book),
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: book.finished ? Icon(Icons.check_box) : null,
          ),
        )
    );
  }
}
