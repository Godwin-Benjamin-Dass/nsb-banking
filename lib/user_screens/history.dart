import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class history extends StatefulWidget {
  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        backgroundColor: Color.fromARGB(255, 162, 0, 255),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/bg.png'), fit: BoxFit.cover)),
        child: SafeArea(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("history")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("transaction")
              .orderBy("time")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            try {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                reverse: true,
                itemBuilder: (_, index) {
                  DocumentSnapshot _DocumentSnapshot =
                      snapshot.data!.docs[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            // image: DecorationImage(
                            //     image: AssetImage('images/card.png'),
                            //     fit: BoxFit.cover)),
                            color: Colors.black),
                        constraints: BoxConstraints(maxWidth: 800),
                        child: ListTile(
                            title: Text(
                              _DocumentSnapshot["ReName"],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Amount : " +
                                  _DocumentSnapshot["status"] +
                                  " ON " +
                                  _DocumentSnapshot["time"],
                              style: TextStyle(color: Colors.green),
                            ),
                            leading: Image.network(_DocumentSnapshot["img"]),
                            trailing: Text(
                              _DocumentSnapshot["amount"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  );
                },
              );
            } catch (e) {
              print('error');
            }
            return Container();
          },
        )),
      ),
    );
  }
}
