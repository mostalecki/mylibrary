import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mylibrary/models/book.dart';
import 'package:mylibrary/models/movie.dart';
import 'package:mylibrary/models/user.dart';
import 'package:mylibrary/services/auth.dart';
import 'package:mylibrary/models/game.dart';

class DatabaseService{

  final FirebaseDatabase _db = FirebaseDatabase.instance;
  User user = AuthService().currentUser;



  Future<bool> addGame(Game game) async{
    DatabaseReference reference = _db.reference().child('db').child(user.uid).child('games').push();
    try{
      reference.set(game.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> editGame(Game game) async{
    try{
      _db.reference().child('db').child(user.uid).child('games').child(game.key).set(game.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> deleteGame(Game game) async{
    try{
      _db.reference().child('db').child(user.uid).child('games').child(game.key).remove();
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> addBook(Book book) async{
    DatabaseReference reference = _db.reference().child('db').child(user.uid).child('books').push();
    try{
      reference.set(book.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> editBook(Book book) async{
    try{
      _db.reference().child('db').child(user.uid).child('books').child(book.key).set(book.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> deleteBook(Book book) async{
    try{
      _db.reference().child('db').child(user.uid).child('books').child(book.key).remove();
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> addMovie(Movie movie, {series=false}) async{
    String collection = series ? 'tvshows' : 'movies';
    DatabaseReference reference = _db.reference().child('db').child(user.uid).child(collection).push();
    try{
      reference.set(movie.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> editMovie(Movie movie, {series=false}) async{
    String collection = series ? 'tvshows' : 'movies';
    try{
      _db.reference().child('db').child(user.uid).child(collection).child(movie.key).set(movie.toJson());
      return true;
    } catch(e){
      return false;
    }
  }

  Future<bool> deleteMovie(Movie movie, {series=false}) async{
    String collection = series ? 'tvshows' : 'movies';
    try{
      _db.reference().child('db').child(user.uid).child(collection).child(movie.key).remove();
      return true;
    } catch(e){
      return false;
    }
  }
}