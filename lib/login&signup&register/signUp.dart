import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/login&signup&register/register.dart';

class sign_up extends StatefulWidget {
  sign_up({Key? key}) : super(key: key);

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                  child: Text(
                    'NSB-Banks \n Welcomes You',
                    textAlign: TextAlign.center,
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
                    "Min 8 characters, including letters, numbers and special characters",
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
                          .createUserWithEmailAndPassword(
                              email: _Emailcontroller.text.toString().trim(),
                              password: _Passwordcontroller.text)
                          .then((value) {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => register()));
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("ERROR ${error.toString()}"),
                          behavior: SnackBarBehavior.floating,
                        ));
                        print("ERROR ${error.toString()}");
                      });
                    },
                    child: Text('   Register   '),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Have an account?'))
              ],
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
