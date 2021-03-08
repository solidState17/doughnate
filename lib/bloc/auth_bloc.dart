import 'package:doughnate/Services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthBloc {
  final authService = AuthService();
  final googleSignin = GoogleSignIn(scopes: ["email"]);

  Stream<User> get currentUser => authService.currentUser;

  loginGoogle() async {

    try{
      final GoogleSignInAccount googleUser = await googleSignin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
      );

      //Firebase Sign In
      final result = await authService.signInCredential(credential);

      print('${result.user.displayName}');

    }catch(err){
      print(err);
    }
  }

}