//import 'UploadScreen.dart';
import 'DownloadScreen.dart';
import 'Register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//Form key
  final _formKey = GlobalKey<FormState>();

//Editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Firebase
  final _auth = FirebaseAuth.instance;
  ////////////

  @override
  Widget build(BuildContext context) {
    //Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      ////////////////////
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please enter your email');
        }
        //Reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Email',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

//Password field
    final passwordField = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordController,
/////////////////////
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Password',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

/////// login button
    final loginButton = Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueAccent,
        elevation: 5,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: (20),
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 130,
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      emailField,
                      const SizedBox(
                        height: 15,
                      ),
                      passwordField,
                      const SizedBox(
                        height: 15,
                      ),
                      loginButton,
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account?"),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationScreen()));
                              },
                              child: const Text("Sign up",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  )))
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                Fluttertoast.showToast(msg: "Logged in successfully"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DownloadScreen()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}

/////login function
