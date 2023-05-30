import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/admin_screens/person_details.dart';

class accepted extends StatelessWidget {
  const accepted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("User_Data").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot x = snapshot.data!.docs[i];
                  if (x['Request'] == "accepted") {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: Image.network(x["photo"]),
                        title: Text(
                          "Person Name: " + x['Name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        subtitle: Text("Phone Number: " + x['PhoneNumber']),
                        onTap: () => [
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonDetails(
                                      value: snapshot.data!.docs[i])))
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                });
          }),
    );
  }
}
