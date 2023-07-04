import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInterface {
  bool _isUserSignedIn = false;

  bool get isUserSignedIn => _isUserSignedIn;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseInterface() {
    initFirebase();
  }

  Future<void> initFirebase() async {
    // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  void checkAuthState() {
    FirebaseAuth.instance.userChanges().listen(handleAuthState);
  }

  void handleAuthState(User? user) {
    if (user == null) {
      _isUserSignedIn = false;
      print('O usuário não está logado!');
    } else {
      _isUserSignedIn = true;
      print('O usuário já está logado!');
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('A senha digitada é fraca! Por favor, insira uma senha mais forte. De preferência que tenha 1 (uma) letra maiúscula, minúsculas, números e ao menos um caractere especial.');
      } else if (e.code == 'email-already-in-use') {
        print('Já existe uma conta com esse email, caso seja você, por favor faça login.');
      }
      return e.code;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Credencias incorretas!');
      } else if (e.code == 'wrong-password') {
        print('Credencias incorretas!');
      }
      return e.code;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      List<UserInfo> providers = user.providerData;

      for (UserInfo userInfo in providers) {
        if (userInfo.providerId == 'google.com') {
          GoogleSignIn googleSignIn = GoogleSignIn();
          await googleSignIn.signOut();
          print('Logout do Google Sign-In realizado.');
        } else if (userInfo.providerId == 'password') {
          await auth.signOut();
          print('Logout de e-mail/senha realizado.');
        }
      }
    }
  }
}
