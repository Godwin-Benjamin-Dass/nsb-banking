import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nsb_bank/login&signup&register/signUp.dart';
import 'package:nsb_bank/user_screens/lobby.dart';

class login extends StatefulWidget {
  login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController _Emailcontroller = TextEditingController();

  TextEditingController _Passwordcontroller = TextEditingController();
  var th = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.png'), fit: BoxFit.cover)),
      child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                    child: Text(
                      'Smart Transactions \n With NSB-Banks',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Email",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        // height: 0.5,
                      ),
                      controller: _Emailcontroller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Color.fromARGB(255, 3, 27, 65),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      obscureText: th == '' ? true : false,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        // height: 0.5,
                      ),
                      controller: _Passwordcontroller,
                      decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                th == ''
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (th == '') {
                                  setState(() {
                                    th = '1';
                                  });
                                } else {
                                  setState(() {
                                    th = '';
                                  });
                                }
                              },
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Color.fromARGB(255, 3, 27, 65),
                          filled: true),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Enter The Password That You Used While Signing Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 15, top: 30.0, left: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 39, 169, 156),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        minimumSize: Size(500, 60),
                      ),
                      onPressed: () async {
                        // SharedPreferences pref =
                        //     await SharedPreferences.getInstance();
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _Emailcontroller.text.toString().trim(),
                                password: _Passwordcontroller.text)
                            .then((value) {
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Lobby()));
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("ERROR ${error.toString()}"),
                            behavior: SnackBarBehavior.floating,
                          ));
                          print("ERROR ${error.toString()}");
                        });
                      },
                      child: Text('   Get Started   '),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => sign_up()));
                      },
                      child: Text('Dont have an account?'))
                ],
              ),
            ),
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // color: Colors.white,
        ),
      ),
    ));
  }
}
