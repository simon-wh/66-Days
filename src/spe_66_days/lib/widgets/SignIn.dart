import 'package:flutter/material.dart';
import 'package:spe_66_days/classes/Global.dart';
import 'package:spe_66_days/widgets/habits/EditNotificationWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ScreenNavigation.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter/src/services/message_codec.dart';

class SignInWidget extends StatefulWidget {
  SignInWidget();

  @override
  State<StatefulWidget> createState() {
    return SignInState();
  }
}

class SignInState extends State<SignInWidget> {
  SignInState();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Widget build(BuildContext context) {
    Global.auth.currentUser().then((user) {
      if (user != null) Navigator.pushReplacementNamed(context, "home");
    });
    //if ((await Global.auth.currentUser() != null){

    //}
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '66  DAYS',
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        body: Builder(builder: (context) => Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SignInButton(Buttons.Google, onPressed: () async {
                  try{

                  final GoogleSignInAccount googleUser =
                      await _googleSignIn.signIn();
                  final GoogleSignInAuthentication googleAuth =
                      await googleUser.authentication;

                  final AuthCredential credential =
                      GoogleAuthProvider.getCredential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  FirebaseUser user = await Global.auth
                      .signInWithCredential(credential)
                      .catchError((err) => print(err));
                  print(user);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ScreenNavigation()));
                  }
                  catch(e){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Login error\n${e.toString()}")));
                  }
                }),
                SignInButton(Buttons.Facebook, onPressed: () async {
                  final facebookLogin = FacebookLogin();
                  final result = await facebookLogin.logInWithReadPermissions(['email']);

                  switch (result.status) {
                    case FacebookLoginStatus.loggedIn:
                      try{
                        FirebaseUser user = await Global.auth.signInWithCredential(FacebookAuthProvider.getCredential(accessToken: result.accessToken.token));
                        print(user);
                        print(user.providerId);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenNavigation()));
                      }
                      catch(e){
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Login error\n${e.toString()}")));
                      }
                      break;
                    case FacebookLoginStatus.cancelledByUser:
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Login cancelled")));
                      break;
                    case FacebookLoginStatus.error:
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Login error. Please try again\n${result.errorMessage}")));
                      break;
                  }


                }),
                SignInButtonBuilder(
                  text: 'Sign in Anonymously',
                  icon: Icons.person,
                  onPressed: () async {
                    FirebaseUser user = await Global.auth.signInAnonymously();
                    print(user);
                    Navigator.pushReplacementNamed(context, "home");
                  },
                  backgroundColor: Colors.blueGrey[700],
                )
              ]),
        )));
  } // Build
} // _HabitsState
