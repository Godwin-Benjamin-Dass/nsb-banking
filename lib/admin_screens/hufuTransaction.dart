import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hufu_Transaction extends StatefulWidget {
  const Hufu_Transaction({super.key});

  @override
  State<Hufu_Transaction> createState() => _Hufu_TransactionState();
}

class _Hufu_TransactionState extends State<Hufu_Transaction> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('hufu').orderBy("time").snapshots();
  DeleteUser(@required id) {
    final docUser =
        FirebaseFirestore.instance.collection("hufu").doc(id.toString());
    return docUser
        .delete()
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Status: Realocated!!.",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.attach_money_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    color: Colors.green,
                  ),
                  title: Text(
                    data['status'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['wallet_amount'].toString()),
                  trailing: Container(
                    color: Colors.green,
                    child: IconButton(
                        onPressed: () {
                          DeleteUser(data['id']);
                        },
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
