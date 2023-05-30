import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/login&signup&register/login.dart';
import 'package:nsb_bank/user_screens/transaction.dart';

class search extends StatefulWidget {
  var balance;
  var sentAmount;
  search({this.balance, this.sentAmount});
  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  var ChatRoomKey;

  CreateChatRooom({@required email}) {
    var myEmail = FirebaseAuth.instance.currentUser!.email;

    if (myEmail.toString().length >= email.toString().length) {
      setState(() {
        ChatRoomKey = email + myEmail;
      });
    } else {
      setState(() {
        ChatRoomKey = email + myEmail;
      });
      ChatRoomKey = myEmail! + email;
    }
    // print(ChatRoomKey);
  }

  @override
  Widget build(BuildContext context) {
    var InputText = "";
    String value = "";
    return FirebaseAuth.instance.currentUser!.email != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 162, 0, 255),
              elevation: 0,
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/bg.png'), fit: BoxFit.cover)),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 600),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            onChanged: ((value) {
                              setState(() {
                                InputText = value;
                              });
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Flexible(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('User_Data')
                                    .where("Email",
                                        isLessThanOrEqualTo:
                                            InputText + "\uf8ff")
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Container(
                                    constraints: BoxConstraints(maxWidth: 600),
                                    child: ListView.builder(
                                        itemCount: snapshot.data?.docs.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data?.docs[index]
                                                  ['Email'] !=
                                              FirebaseAuth.instance.currentUser!
                                                  .email) {
                                            String ItemTitle = snapshot
                                                .data?.docs[index]['Name'];
                                            String image = snapshot
                                                .data?.docs[index]['photo'];

                                            int balance = snapshot
                                                .data?.docs[index]['Balance'];

                                            QueryDocumentSnapshot x =
                                                snapshot.data!.docs[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 29, 4, 105),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title: Text(
                                                      ItemTitle,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30),
                                                    ),
                                                    leading: Container(
                                                        width: 90.0,
                                                        height: 90.0,
                                                        decoration: new BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: new DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image:
                                                                    new NetworkImage(
                                                                        image)))),
                                                    onTap: () {
                                                      print(widget.balance);
                                                      // print(ChatRoomKey);
                                                      CreateChatRooom(
                                                          email: snapshot.data
                                                                  ?.docs[index]
                                                              ['Email']);
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  transactionDm(
                                                                    eligible: snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        [
                                                                        'Request'],
                                                                    reciverimage:
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[index]['photo'],
                                                                    sent: widget
                                                                        .sentAmount,
                                                                    recived: snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        [
                                                                        'received'],
                                                                    Rebalance: snapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        [
                                                                        'Balance'],
                                                                    balance: widget
                                                                        .balance,
                                                                    reciverEmail:
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[index]['Email'],
                                                                    ChatRoomId:
                                                                        ChatRoomKey,
                                                                    reciverName:
                                                                        snapshot
                                                                            .data
                                                                            ?.docs[index]['Name'],
                                                                  )));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  );
                                }))
                      ],
                    ),
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
