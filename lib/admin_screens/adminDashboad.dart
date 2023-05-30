import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nsb_bank/admin_screens/accepted.dart';
import 'package:nsb_bank/admin_screens/adminServer.dart';
import 'package:nsb_bank/admin_screens/banned.dart';
import 'package:nsb_bank/admin_screens/waiting.dart';

class AdminDash extends StatefulWidget {
  const AdminDash({super.key});

  @override
  State<AdminDash> createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => adminServer()));
              },
              icon: Icon(Icons.settings))
        ],
        title: Text("MEMBERS"),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.done),
                  text: "Accepted",
                ),
                Tab(icon: Icon(Icons.handshake_rounded), text: "Waiting"),
                Tab(icon: Icon(Icons.no_accounts_rounded), text: "Banned"),
              ],
            ),
            title: Text('Details'),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            children: [accepted(), waiting(), banned()],
          ),
        ),
      ),
    );
  }
}
