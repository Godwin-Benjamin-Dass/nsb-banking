import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/user_screens/lobby.dart';

class transactionDm extends StatefulWidget {
  var ChatRoomId;
  var reciverName;
  var reciverEmail;
  var reciverimage;
  var balance;
  var Rebalance;
  var sent;
  var recived;
  var eligible;
  transactionDm(
      {this.reciverName,
      this.reciverEmail,
      this.reciverimage,
      this.balance,
      this.sent,
      this.recived,
      this.Rebalance,
      this.eligible,
      this.ChatRoomId});
  @override
  State<transactionDm> createState() => _transactionDmState();
}

class _transactionDmState extends State<transactionDm> {
  var email = FirebaseAuth.instance.currentUser!.email;

  UpdateDetails() {
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("Chats");
    return _CollectionReference.doc(widget.ChatRoomId).set({
      "user1": email,
      "user1image": FirebaseAuth.instance.currentUser!.photoURL,
      "User1name": FirebaseAuth.instance.currentUser!.displayName,
      "user2": widget.reciverEmail,
      "User2image": widget.reciverimage,
      "User2name": widget.reciverName,
      "chatroomid": widget.ChatRoomId.toString(),
      "Time": DateTime.now().toString()
    });
  }

  Future addsendertrans({@required amount, com}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("history");
    return _collectionref
        .doc(currentUser!.email)
        .collection("transaction")
        .doc()
        .set({
      "img": widget.reciverimage,
      'MyEmail': email,
      'ReName': widget.reciverName,
      'amount': amount,
      "status": "SENT ${com}",
      'time': DateTime.now().toString()
    });
  }

  Future addrecitrans({@required amount, com}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("history");
    return _collectionref
        .doc(widget.reciverEmail)
        .collection("transaction")
        .doc()
        .set({
      "img": FirebaseAuth.instance.currentUser!.photoURL,
      'MyEmail': widget.reciverName,
      'ReName': email,
      'amount': amount,
      "status": "Recived ${com}",
      'time': DateTime.now().toString()
    });
  }

  Future addresevertrans({@required amount}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    CollectionReference _collectionref =
        FirebaseFirestore.instance.collection("history");
    return _collectionref
        .doc(widget.reciverEmail)
        .collection("transaction")
        .doc()
        .set({
      "image": FirebaseAuth.instance.currentUser!.photoURL,
      'MyEmail': widget.reciverEmail,
      'ReName': FirebaseAuth.instance.currentUser!.displayName,
      'amount': amount,
      "status": "RECEIVED",
      'time': DateTime.now().toString()
    });
  }

  AddCrediblity() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
        .update({"Crediblity": "Rejected", "user": ""}).then((value) {
      Navigator.of(context).pop();
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('server');

  hufu({@required amount}) {
    int amounts = int.parse(amount);
    int balance = widget.balance;
    print(balance);
    if (amounts > balance) {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "ERROR: Insufficent Funds.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      int rebalance = widget.Rebalance + amounts;
      int balance = widget.balance - amounts;
      int sent = widget.sent + amounts;
      int recived = widget.recived + amounts;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      CollectionReference _CollectionReference =
          FirebaseFirestore.instance.collection("User_Data");

      return _CollectionReference.doc(widget.reciverEmail)
          .update({"Balance": rebalance, "received": recived}).then((value) {
        _CollectionReference.doc(FirebaseAuth.instance.currentUser!.email)
            .update({"Balance": balance, "Sent": sent});
        storemessage
            .collection("Chats")
            .doc(widget.ChatRoomId)
            .collection("messages")
            .doc()
            .set({
          "amount": amounts,
          "User1": widget.reciverEmail,
          "User2": email,
          'time': DateTime.now().toString()
        }).then((value) {
          print("1");
          final hufu = FirebaseFirestore.instance.collection("hufu").doc();
          return hufu.set({
            "id": hufu.id,
            "status": "reciving",
            "wallet_amount": amounts,
            "reciver": widget.reciverEmail,
            "sender": email,
            "time": DateTime.now().toString(),
            "Pending": "waiting"
          }).then((value) {
            print("2");
            final hufu = FirebaseFirestore.instance.collection("hufu").doc();
            return hufu.set({
              "id": hufu.id,
              "status": "sending",
              "wallet_amount": amounts,
              "reciver": widget.reciverEmail,
              "sender": email,
              'time': DateTime.now().toString(),
              "Pending": "waiting"
            }).then((value) {
              print("3");
              addsendertrans(amount: amounts, com: "A.N.B");
              addrecitrans(amount: amounts, com: "A.N.B")
                  .then((value) => Navigator.pop(context));
              _amountContoller.clear();
              _PassContoller.clear();
            });
          });
        });
      });
    }
  }

  _proceedTransaction({@required amount, @required val}) {
    int amounts = int.parse(amount);
    int balance = widget.balance;
    print(balance);
    if (amounts > balance) {
      Navigator.pop(context);
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "ERROR: Insufficent Funds.",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    } else {
      int rebalance = widget.Rebalance + amounts;
      int balance = widget.balance - amounts;
      int sent = widget.sent + amounts;
      int recived = widget.recived + amounts;
      final FirebaseAuth _auth = FirebaseAuth.instance;
      CollectionReference _CollectionReference =
          FirebaseFirestore.instance.collection("User_Data");
      return _CollectionReference.doc(widget.reciverEmail)
          .update({"Balance": rebalance, "received": recived}).then((value) {
        final FirebaseAuth _auth = FirebaseAuth.instance;
        CollectionReference _CollectionReference =
            FirebaseFirestore.instance.collection("User_Data");
        if (val == 1) {
          return _CollectionReference.doc(
                  FirebaseAuth.instance.currentUser!.email)
              .update({"Balance": balance, "Sent": sent}).then((value) {
            storemessage
                .collection("Chats")
                .doc(widget.ChatRoomId)
                .collection("messages")
                .doc()
                .set({
              "amount": amounts,
              "User1": widget.reciverEmail,
              "User2": email,
              'time': DateTime.now().toString()
            }).then((value) {
              _amountContoller.clear();
              _PassContoller.clear();
              addrecitrans(amount: amounts, com: "");
              addsendertrans(amount: amounts, com: "")
                  .then((value) => Navigator.pop(context));
            });
          });
        }
      });
    }
  }

  TextEditingController _amountContoller = TextEditingController();

  TextEditingController _PassContoller = TextEditingController();
  final storemessage = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UpdateDetails();
  }

  var button = 'on';

  @override
  Widget build(BuildContext context) {
    return widget.eligible == "accepted"
        ? Scaffold(
            // backgroundColor: Colors.grey,
            appBar: AppBar(
              title: Text(widget.reciverName),
            ),
            body: Center(
              child: Container(
                // constraints: BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/bg.png"), fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("Chats")
                                  .doc(widget.ChatRoomId)
                                  .collection("messages")
                                  .orderBy('time')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                return ListView.builder(
                                    physics: ScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    shrinkWrap: true,
                                    primary: true,
                                    itemBuilder: (context, i) {
                                      QueryDocumentSnapshot x =
                                          snapshot.data!.docs[i];
                                      return ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              email == x['User2']
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            SafeArea(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: email ==
                                                                x['User2']
                                                            ? Colors.red
                                                            : Colors.lightBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Amount: " +
                                                                x['amount']
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(x['time'],
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ],
                                                      ),
                                                    ))),
                                            Text(
                                              x['User2'],
                                              style: TextStyle(fontSize: 8),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }),
                        ),
                      ),
                    ),
                    FutureBuilder<DocumentSnapshot>(
                      future: users.doc("server").get(),
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
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 3, 236, 42)),
                                onPressed: () {
                                  if (_amountContoller.text != "") {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Enter Password"),
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      obscureText: true,
                                                      controller:
                                                          _PassContoller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  button == 'on'
                                                      ? ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          222,
                                                                          81,
                                                                          70)),
                                                          onPressed: () {
                                                            FirebaseAuth
                                                                .instance
                                                                .signInWithEmailAndPassword(
                                                                    email: FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .email
                                                                        .toString(),
                                                                    password:
                                                                        _PassContoller
                                                                            .text)
                                                                .then((value) {
                                                              if (data[
                                                                      'server'] ==
                                                                  "Active") {
                                                                _proceedTransaction(
                                                                    amount: _amountContoller
                                                                        .text
                                                                        .trim(),
                                                                    val: 1);
                                                              } else if (data[
                                                                      'server'] ==
                                                                  "In-Active") {
                                                                hufu(
                                                                    amount: _amountContoller
                                                                        .text
                                                                        .trim());
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                    "ERROR: Transaction Is Paused Please Contact Administrator.",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                ));
                                                              }
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                  "ERROR: Invalid Password.",
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
                                                          },
                                                          child:
                                                              Text('Proceed'))
                                                      : Container()
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "ERROR: Amount Cannot Be Empty.",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                    ));
                                  }
                                },
                                child: Icon(Icons.rocket),
                              ),
                            ),
                          );
                          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                        }

                        return Text("loading");
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        // constraints: BoxConstraints(maxWidth: 800),
                        child: TextField(
                            textAlign: TextAlign.center,
                            controller: _amountContoller,
                            decoration: InputDecoration(
                              hintText: "   Send amount",
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Text("The User Is Not Ready To Recieve Money"),
            ),
          );
  }
}
