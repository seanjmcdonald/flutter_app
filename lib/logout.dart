import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

Future<LoginPage>_logOut() async{
  await FirebaseAuth.instance.signOut();
  return LoginPage();
}
