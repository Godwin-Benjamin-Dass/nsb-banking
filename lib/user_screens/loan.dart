import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/login&signup&register/login.dart';
import 'dart:math' as math;

class loan extends StatefulWidget {
  var email;

  loan({
    required this.email,
  });

  @override
  State<loan> createState() => _loanState();
}

class _loanState extends State<loan> {
  TextEditingController _AmountController = TextEditingController();

  TextEditingController _PassController = TextEditingController();

  CollectionReference users =
      FirebaseFirestore.instance.collection('User_Data');

  Future addDeposit({@required amount, com}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("history");
    return _collectionref
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("transaction")
        .doc()
        .set({
      "img": FirebaseAuth.instance.currentUser!.photoURL,
      'MyEmail': FirebaseAuth.instance.currentUser!.email,
      'ReName': FirebaseAuth.instance.currentUser!.displayName,
      'amount': amount,
      "status": com,
      'time': DateTime.now().toString()
    });
  }

  AddAmount({@required balance, @required amount, @required loangot}) async {
    var total = balance + int.parse(amount);
    var loan = loangot + int.parse(amount);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
        .update({"Balance": total, "LoanGot": loan}).then((value) {
      addDeposit(amount: _AmountController.text.trim(), com: "Recived Loan");
      _AmountController.clear;
      _PassController.clear;
      setState(() {});
      Navigator.of(context).pop();
    });
  }

  repayAmount(
      {@required balance, @required amount, @required repayloan}) async {
    var total = balance - int.parse(amount);
    var repaid = repayloan + int.parse(amount);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
        .update({"Balance": total, "Repaid": repaid}).then((value) {
      addDeposit(amount: _AmountController.text.trim(), com: "Repaid Loan");
      _AmountController.clear;
      _PassController.clear;
      setState(() {});
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('User_Data');
    return widget.email != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 162, 0, 255),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: FutureBuilder<DocumentSnapshot>(
                    future: users.doc(widget.email).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        int cr = (data['Sent'] / 10000).floor();
                        num lim =
                            (cr * 1000) - data['LoanGot'] + data['Repaid'];
                        return Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/bg.png'),
                                  fit: BoxFit.cover)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // alignment: Alignment.center,
                                  constraints: BoxConstraints(maxWidth: 1000),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 21, 22, 81),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Credibility: ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      //${data['Crediblity']}

                                      Text(cr.toString(),
                                          style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.data_exploration_rounded,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                    "Your Crediblity Depends upon your transaction",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                Text("1 Crediblity Per 10k Transaction",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                Text("1 Crediblity = 1k Loan",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                Text("Your current loan limit= " + "$lim Rs",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Loan you've got: " +
                                          "${data['LoanGot']} ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.currency_rupee_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Amount you've Repaid: " +
                                          "${data['Repaid']} ",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Icon(
                                      Icons.currency_rupee_rounded,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 600),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
                                    color: Color.fromARGB(255, 21, 22, 81),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              title: Text('Enter amount'),
                                              content: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _AmountController,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter Amount"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _PassController,
                                                      obscureText: true,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter Password"),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        if ((int.parse(
                                                                _AmountController
                                                                    .text) >
                                                            lim)) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              "ERROR: Your Limit Is $lim",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                          Navigator.pop(
                                                              context);
                                                        } else if (_AmountController
                                                                    .text !=
                                                                "" &&
                                                            _PassController !=
                                                                "") {
                                                          FirebaseAuth.instance
                                                              .signInWithEmailAndPassword(
                                                                  email: FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email
                                                                      .toString(),
                                                                  password:
                                                                      _PassController
                                                                          .text)
                                                              .then((value) {
                                                            AddAmount(
                                                                loangot: data[
                                                                    "LoanGot"],
                                                                balance: data[
                                                                    "Balance"],
                                                                amount:
                                                                    _AmountController
                                                                        .text);
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "ERROR: Fields Can't Be Empty",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ));
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              "ERROR: Fields Can't Be Empty",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                        }
                                                      },
                                                      child: Text("Get Loan")),
                                                ],
                                              )));
                                    },
                                    height: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sports_volleyball_outlined,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          Text(
                                            "Get Loan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 600),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.0))),
                                    color: Color.fromARGB(255, 21, 22, 81),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                              title: Text('Enter amount'),
                                              content: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _AmountController,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter Amount"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _PassController,
                                                      obscureText: true,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter Password"),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        if ((int.parse(
                                                                _AmountController
                                                                    .text) >
                                                            data['LoanGot'] -
                                                                data[
                                                                    'Repaid'])) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              "ERROR: Your Limit Is $lim",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                          Navigator.pop(
                                                              context);
                                                        } else if (_AmountController
                                                                    .text !=
                                                                "" &&
                                                            _PassController !=
                                                                "") {
                                                          FirebaseAuth.instance
                                                              .signInWithEmailAndPassword(
                                                                  email: FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email
                                                                      .toString(),
                                                                  password:
                                                                      _PassController
                                                                          .text)
                                                              .then((value) {
                                                            repayAmount(
                                                                repayloan: data[
                                                                    "Repaid"],
                                                                balance: data[
                                                                    "Balance"],
                                                                amount:
                                                                    _AmountController
                                                                        .text);
                                                          }).onError((error,
                                                                  stackTrace) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                "ERROR: Fields Can't Be Empty",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                            ));
                                                          });
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  SnackBar(
                                                            content: Text(
                                                              "ERROR: Fields Can't Be Empty",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            backgroundColor:
                                                                Colors.red,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .floating,
                                                          ));
                                                        }
                                                      },
                                                      child: Text("Get Loan")),
                                                ],
                                              )));
                                    },
                                    height: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.sports_volleyball_outlined,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          Text(
                                            "Repay Loan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Text("loading");
                    },
                  ))
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something Went Wrong, Login Again'),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => login()));
                      },
                      child: Text('Login page'))
                ],
              ),
            ),
          );
  }
}
