import 'dart:ui';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class register extends StatefulWidget {
  register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final proof_type = ["Aadhar", "Voter id", "Lisence", "Pan Card"];
  String? person;
  String? proof;
  String? proofName;
  String? value;

  TextEditingController _NameController = TextEditingController();

  TextEditingController _EmailController = TextEditingController();

  TextEditingController _PhoneNoController = TextEditingController();

  TextEditingController _AddressController = TextEditingController();

  _SendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentuser = _auth.currentUser;
    List<String> dropdownValue = <String>[
      'Aadhar',
      'Voter Id',
      'Lisence',
      'Pan Card'
    ];
    _SetUserData() async {
      await _auth.currentUser!.updateDisplayName(_NameController.text);
      await _auth.currentUser!.updatePhotoURL(person);
    }

    CollectionReference _CollectionReference =
        FirebaseFirestore.instance.collection("User_Data");
    return _CollectionReference.doc(currentuser!.email).set({
      "photo": person,
      "Balance": 0,
      "Sent": 0,
      "received": 0,
      "Request": "waiting",
      "user": "user",
      "id_proof": proof,
      "id_proof_name": value,
      "Crediblity": 0,
      "Name": _NameController.text,
      "Email": FirebaseAuth.instance.currentUser!.email,
      "PhoneNumber": _PhoneNoController.text,
      "Address": _AddressController.text,
      "LoanGot": 0,
      "Repaid": 0
    }).then((value) {
      _SetUserData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Details Of The User Has Been Added"),
        behavior: SnackBarBehavior.floating,
      ));
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("ERROR ${onError.toString()}"),
        behavior: SnackBarBehavior.floating,
      ));
    });
  }

  uploadDpToStorage() {
    FirebaseStorage fs = FirebaseStorage.instance;
    FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
    input.accept = '.png,.jpg';
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(file!);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child(file.name).putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          person = downloadUrl;
        });
      });
    });
  }

  uploadDocToStorage() {
    FirebaseStorage fs = FirebaseStorage.instance;
    FileUploadInputElement inputs = FileUploadInputElement()
      ..accept = 'image/*';
    inputs.accept = '.png,.jpg';
    inputs.click();
    inputs.onChange.listen((event) {
      final files = inputs.files?.first;
      final reader = FileReader();
      reader.readAsDataUrl(files!);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child(files.name).putBlob(files);
        String downloadUrls = await snapshot.ref.getDownloadURL();
        setState(() {
          proof = downloadUrls;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.redAccent[200],
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/bg.png'), fit: BoxFit.cover)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  Text(
                    'Submit to continue',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  person == null
                      ? IconButton(
                          onPressed: () {
                            uploadDpToStorage();
                          },
                          icon: Icon(Icons.add))
                      : Image.network(
                          person.toString(),
                          height: 70,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Add Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Full Name",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        // height: 0.5,
                      ),
                      controller: _NameController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Color.fromARGB(255, 3, 27, 65),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Phone Number",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        // height: 0.5,
                      ),
                      controller: _PhoneNoController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Color.fromARGB(255, 3, 27, 65),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Address",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        // height: 0.5,
                      ),
                      controller: _AddressController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          fillColor: Color.fromARGB(255, 3, 27, 65),
                          filled: true),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 30.0, left: 8),
                    child: proof == null
                        ? IconButton(
                            onPressed: () {
                              uploadDocToStorage();
                            },
                            icon: Icon(Icons.add))
                        : Image.network(
                            proof.toString(),
                            height: 70,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Supporting Document Name",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: ListTile(
                      title: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 1)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              hint: Text(
                                'Select Proof Type ',
                                style:
                                    TextStyle(fontSize: 17, color: Colors.grey),
                              ),
                              value: value,
                              style: TextStyle(color: Colors.black),
                              iconSize: 16 * 2,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              items: proof_type.map(buildMenuItem).toList(),
                              onChanged: (value) => setState(() {
                                    this.value = value;
                                  })),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, top: 30.0, left: 8),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 39, 169, 156),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          minimumSize: Size(500, 60),
                        ),
                        onPressed: () {
                          if (value != null &&
                              person != null &&
                              _NameController.text != "" &&
                              _PhoneNoController != "" &&
                              _AddressController != "" &&
                              proof != null)
                            _SendUserDataToDB();
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("ERROR: Details Cant Be Empty"),
                              behavior: SnackBarBehavior.floating,
                            ));
                          }
                        },
                        child: Text('   Continue   ')),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ));
  DropdownMenuItem<String> buildMenureq_units(String req_units) =>
      DropdownMenuItem(
          value: req_units,
          child: Text(
            req_units,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
}
