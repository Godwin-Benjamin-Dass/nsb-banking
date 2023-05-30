import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonDetails extends StatefulWidget {
  var value;
  PersonDetails({this.value});

  @override
  State<PersonDetails> createState() => _PersonDetailsState();
}

class _PersonDetailsState extends State<PersonDetails> {
  CollectionReference _CollectionReference =
      FirebaseFirestore.instance.collection("User_Data");
  _accept({@required email}) {
    _CollectionReference.doc(email).update({"Request": "accepted"});
  }

  _wait({@required email}) {
    _CollectionReference.doc(email).update({"Request": "waiting"});
  }

  _reject({@required email}) {
    _CollectionReference.doc(email).update({"Request": "rejected"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.value["Name"]),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.value["photo"], height: 150),
                ),
                Text(
                  "Person Name: " + widget.value["Name"],
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Text("Person Email: " + widget.value["Email"],
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                Text("Person Phone Number: " + widget.value["PhoneNumber"],
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                Text("Person Address: " + widget.value["Address"],
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                Text("Person Id_Name: " + widget.value["id_proof_name"],
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.value["id_proof"], height: 150),
                ),
                Text("Person Status: " + widget.value["Request"],
                    style:
                        TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                widget.value["Request"] == "waiting"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _accept(email: widget.value["Email"]);
                              },
                              child: Text("Accept")),
                          ElevatedButton(
                              onPressed: () {
                                _reject(email: widget.value["Email"]);
                              },
                              child: Text("Reject"))
                        ],
                      )
                    : Container(),
                widget.value["Request"] == "accepted"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _wait(email: widget.value["Email"]);
                              },
                              child: Text("Move To Waiting")),
                          ElevatedButton(
                              onPressed: () {
                                _reject(email: widget.value["Email"]);
                              },
                              child: Text("Reject"))
                        ],
                      )
                    : Container(),
                widget.value["Request"] == "rejected"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _reject(email: widget.value["Email"]);
                              },
                              child: Text("Accept")),
                          ElevatedButton(
                              onPressed: () {
                                _accept(email: widget.value["Email"]);
                              },
                              child: Text("Move To Waiting"))
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
