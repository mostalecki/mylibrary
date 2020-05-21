import 'package:firebase_auth/firebase_auth.dart';
import 'package:mylibrary/models/user.dart';

class AuthService {

  static final AuthService _authService = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;

  factory AuthService(){
    return _authService;
  }

  AuthService._internal();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future<String> signIn(String email, String password) async {

    String errorMessage = 'Something went wrong. Try again later';

    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch(error){
      switch(error.code){
        case 'ERROR_USER_NOT_FOUND':
          errorMessage = 'Invalid email or password';
          break;
        case 'ERROR_WRONG_PASSWORD':
          errorMessage = 'Invalid email or password';
          break;

      }
      return errorMessage;
    }
  }

  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<String> signUp(String email, String password) async {

    String errorMessage = 'Something went wrong. Try again later';

    try{
      AuthResult result =  await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } catch(e){
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
        errorMessage = 'Email already in use';
      }
      return errorMessage;
    }
  }
}