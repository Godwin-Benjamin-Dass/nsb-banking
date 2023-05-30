import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/admin_screens/hufuTransaction.dart';

class adminServer extends StatefulWidget {
  const adminServer({super.key});

  @override
  State<adminServer> createState() => _adminServerState();
}

class _adminServerState extends State<adminServer> {
  CollectionReference users = FirebaseFirestore.instance.collection('server');
  // Activate() {
  //   users.doc("server").update({"server": "Active"});
  // }

  // Deactivate() {
  //   users.doc('server').update({"server": "In-Active"});
  // }

  _active() {
    users.doc("server").update({"server": "Active"}).then((value) {
      setState(() {});
    });
  }

  _deactive() {
    users.doc("server").update({"server": "In-Active"}).then((value) {
      setState(() {});
    });
  }

  _stop() {
    users.doc("server").update({"server": "STOP"}).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Server Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc("server").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.red,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Server Status: ${data['server']}",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if (data['server'] == "Active") {
                            _deactive();
                          } else {
                            _active();
                          }
                        },
                        child: Text(data['server'] == "Active" ? "OFF" : "ON")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Hufu_Transaction()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Show Transaction During In-Active",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          _stop();
                        },
                        child: Text("Stop Transaction")),
                  ),
                ],
              ),
            );
          }

          return Center(child: Text("loading"));
        },
      ),
    );
  }
}
