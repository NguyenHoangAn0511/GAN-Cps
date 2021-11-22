import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gan_compress/homepage.dart';
import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Penstagram'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

  void click() {
    signInWithGoogle().then((user) => {
          this.user = user,
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyHomePage(user)))
        });
  }

  Widget googleLoginButton() {
    return Container(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Image.asset('assets/images/MMLAB.png',
          // width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.width,
          fit: BoxFit.contain),
      OutlinedButton(
        onPressed: this.click,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return Theme.of(context).colorScheme.primary.withOpacity(0.5);
              return null; // Use the component's default.
            },
          ),
        ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        // splashColor: Colors.grey,
        // borderSide: BorderSide(color: Colors.grey),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/google_logo.png'), height: 35),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Sign in with Google',
                        style: TextStyle(color: Colors.white, fontSize: 25)))
              ],
            )),
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}
