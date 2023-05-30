import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nsb_bank/admin_screens/adminDashboad.dart';
import 'package:nsb_bank/login&signup&register/login.dart';
import 'package:nsb_bank/login&signup&register/register.dart';
import 'package:nsb_bank/user_screens/history.dart';
import 'package:nsb_bank/user_screens/loan.dart';
import 'package:nsb_bank/user_screens/search.dart';

class Lobby extends StatelessWidget {
  Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1000) {
        return Destop_view();
      } else {
        return mobile_view();
      }
    });
  }
}

class Destop_view extends StatefulWidget {
  const Destop_view({super.key});
  static CollectionReference users =
      FirebaseFirestore.instance.collection('User_Data');

  @override
  State<Destop_view> createState() => _Destop_viewState();
}

class _Destop_viewState extends State<Destop_view> {
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
      "status": "Deposited ",
      'time': DateTime.now().toString()
    });
  }

  AddAmount({@required balance, @required amount}) async {
    var total = balance + int.parse(amount);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "Balance": total,
    }).then((value) {
      addDeposit(amount: _AmountController.text.trim());
      _AmountController.clear;
      _PassController.clear;
      setState(() {});
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    String img = FirebaseAuth.instance.currentUser!.photoURL.toString();
    return FirebaseAuth.instance.currentUser != null
        ? Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bg.png'), fit: BoxFit.cover)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Flexible(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: Destop_view.users
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            try {
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }

                              if (snapshot.hasData && !snapshot.data!.exists) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => register()));
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                if (data['Request'] == "waiting") {
                                  return Center(
                                    child: Text(
                                        "Your Request Is Pending So Wait Until The Manager Verifies Your Identity"),
                                  );
                                } else if (data['Request'] == "rejected") {
                                  return Center(
                                    child: Text(
                                        "Your Request Is Rejected Contact The Customer Care"),
                                  );
                                } else if (data['Request'] == "accepted") {
                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 1200),
                                              alignment: Alignment.topCenter,
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 50, 10, 67),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width: 70.0,
                                                        height: 70.0,
                                                        decoration: new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: new DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image:
                                                                    new NetworkImage(
                                                                        img)))),
                                                    Text(
                                                      "  Welcome : ${FirebaseAuth.instance.currentUser!.displayName} ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          elevation: 10,
                                          child: Container(
                                              // alignment: Alignment.center,
                                              constraints: BoxConstraints(
                                                  maxWidth: 700,
                                                  minHeight: 400),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/card.png'),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Balance ",
                                                            style: TextStyle(
                                                                fontSize: 50,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .currency_rupee_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 50,
                                                            ),
                                                            Text(
                                                              "${data['Balance']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 45),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                        ),
                                                        Text(
                                                            "Account Holder Name ",
                                                            style: TextStyle(
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                          "${data['Name']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Text("GISA",
                                                            style: TextStyle(
                                                                fontSize: 40,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          height: 100,
                                                        ),
                                                        Text(
                                                          "Expiry Date",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          "04/25",
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        SizedBox(
                                                          height: 50,
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.refresh,
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 70,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => loan(
                                                                email: FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .email)));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Loans",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    height: 380,
                                                    width: 350,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    search(
                                                                      sentAmount:
                                                                          data[
                                                                              'Sent'],
                                                                      balance: data[
                                                                          'Balance'],
                                                                    )));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Send Money",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    height: 380,
                                                    width: 350,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    history()));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Transcaction History",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    height: 380,
                                                    width: 350,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) =>
                                                            AlertDialog(
                                                                title: Text(
                                                                    'Enter amount'),
                                                                content: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _AmountController,
                                                                        decoration:
                                                                            InputDecoration(hintText: "Enter Amount"),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _PassController,
                                                                        obscureText:
                                                                            true,
                                                                        decoration:
                                                                            InputDecoration(hintText: "Enter Password"),
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (_AmountController.text != "" &&
                                                                              _PassController != "") {
                                                                            FirebaseAuth.instance.signInWithEmailAndPassword(email: FirebaseAuth.instance.currentUser!.email.toString(), password: _PassController.text).then(
                                                                                (value) {
                                                                              AddAmount(balance: data["Balance"], amount: _AmountController.text);
                                                                            }).onError((error,
                                                                                stackTrace) {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text(
                                                                                  "ERROR: Fields Can't Be Empty",
                                                                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                ),
                                                                                backgroundColor: Colors.red,
                                                                                behavior: SnackBarBehavior.floating,
                                                                              ));
                                                                            });
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(
                                                                                "ERROR: Fields Can't Be Empty",
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              backgroundColor: Colors.red,
                                                                              behavior: SnackBarBehavior.floating,
                                                                            ));
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                            "Deposit")),
                                                                  ],
                                                                )));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Deposit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        border: Border.all(
                                                            color:
                                                                Colors.white)),
                                                    height: 380,
                                                    width: 350,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        data["user"] == "admin"
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AdminDash()));
                                                },
                                                child: Text("Admin Options"))
                                            : Container()
                                      ],
                                    ),
                                  );
                                }
                              }

                              return Text("loading");
                            } catch (e) {
                              print(e);
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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

class mobile_view extends StatefulWidget {
  @override
  State<mobile_view> createState() => _mobile_viewState();
}

class _mobile_viewState extends State<mobile_view> {
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
      "status": "Deposited ",
      'time': DateTime.now().toString()
    });
  }

  AddAmount({@required balance, @required amount}) async {
    var total = balance + int.parse(amount);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      "Balance": total,
    }).then((value) {
      addDeposit(amount: _AmountController.text.trim());
      _AmountController.clear;
      _PassController.clear;
      setState(() {});
      Navigator.of(context).pop();
    });
  }

  String img = FirebaseAuth.instance.currentUser!.photoURL.toString();

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? Scaffold(
            body: Center(
              child: Column(
                children: [
                  Flexible(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: users
                          .doc(FirebaseAuth.instance.currentUser!.email)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        try {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => register()));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            if (data['Request'] == "waiting") {
                              return Center(
                                child: Text(
                                    "Your Request Is Pending So Wait Until The Manager Verifies Your Identity"),
                              );
                            } else if (data['Request'] == "rejected") {
                              return Center(
                                child: Text(
                                    "Your Request Is Rejected Contact The Customer Care"),
                              );
                            } else if (data['Request'] == "accepted") {
                              return Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/bg.png'),
                                        fit: BoxFit.cover)),
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // Container(
                                        //     alignment: Alignment.topLeft,
                                        //     width: 40.0,
                                        //     height: 40.0,
                                        //     decoration: new BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         image: new DecorationImage(
                                        //             fit: BoxFit.cover,
                                        //             image: new NetworkImage(
                                        //                 img)))),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "  Welcome : \n${FirebaseAuth.instance.currentUser!.displayName} ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          elevation: 10,
                                          child: Container(
                                              // alignment: Alignment.center,
                                              constraints: BoxConstraints(
                                                  maxWidth: 250,
                                                  maxHeight: 150),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'images/card.png'),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text("Balance ",
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .currency_rupee_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 17,
                                                            ),
                                                            Text(
                                                              "${data['Balance']}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 60,
                                                        ),
                                                        Text(
                                                            "Account Holder Name ",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                          "${data['Name']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Column(
                                                      children: [
                                                        Text("GISA",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(
                                                          height: 80,
                                                        ),
                                                        Text(
                                                          "Expiry Date",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 8,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Text(
                                                          "04/25",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.refresh,
                                              color: Colors.white,
                                            )),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => loan(
                                                              email: FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .email)));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Loans",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  height: 140,
                                                  width: 120,
                                                ),
                                              ),
                                            ),
                                            // Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              search(
                                                                sentAmount:
                                                                    data[
                                                                        'Sent'],
                                                                balance: data[
                                                                    'Balance'],
                                                              )));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Send Money",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  height: 140,
                                                  width: 120,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              history()));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Transaction History",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  height: 140,
                                                  width: 120,
                                                ),
                                              ),
                                            ),
                                            // Spacer(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          AlertDialog(
                                                              title: Text(
                                                                  'Enter amount'),
                                                              content: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          _AmountController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                              hintText: "Enter Amount"),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        TextField(
                                                                      controller:
                                                                          _PassController,
                                                                      obscureText:
                                                                          true,
                                                                      decoration:
                                                                          InputDecoration(
                                                                              hintText: "Enter Password"),
                                                                    ),
                                                                  ),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (_AmountController.text !=
                                                                                "" &&
                                                                            _PassController !=
                                                                                "") {
                                                                          FirebaseAuth
                                                                              .instance
                                                                              .signInWithEmailAndPassword(email: FirebaseAuth.instance.currentUser!.email.toString(), password: _PassController.text)
                                                                              .then((value) {
                                                                            AddAmount(
                                                                                balance: data["Balance"],
                                                                                amount: _AmountController.text);
                                                                          }).onError((error, stackTrace) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(
                                                                                "ERROR: Fields Can't Be Empty",
                                                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              backgroundColor: Colors.red,
                                                                              behavior: SnackBarBehavior.floating,
                                                                            ));
                                                                          });
                                                                        } else {
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text(
                                                                              "ERROR: Fields Can't Be Empty",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                            behavior:
                                                                                SnackBarBehavior.floating,
                                                                          ));
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                          "Deposit")),
                                                                ],
                                                              )));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Deposit",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      border: Border.all(
                                                          color: Colors.white)),
                                                  height: 140,
                                                  width: 120,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        data["user"] == "admin"
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AdminDash()));
                                                },
                                                child: Text("Admin Options"))
                                            : Container()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          return Container();
                        }

                        return Text("loading");
                      },
                    ),
                  ),
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
