import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(FrstPg());
}

class FrstPg extends StatefulWidget {
  const FrstPg({Key? key}) : super(key: key);

  @override
  State<FrstPg> createState() => _MyAppState();
}

class _MyAppState extends State<FrstPg> {
  late String _name, _dob, _phoneNumber;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: InputDecoration(label: Text("Name")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your name";
                      }
                    },
                    onSaved: (newValue) {
                      _name = newValue.toString().trim();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text("Phone number")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your name";
                      }
                    },
                    onSaved: (newValue) {
                      _phoneNumber = newValue.toString().trim();
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(label: Text("DOB")),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your name";
                      }
                    },
                    onSaved: (newValue) {
                      _dob = newValue.toString().trim();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          color: Colors.yellowAccent[700],
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              enterUserDetails(_dob, _name, _phoneNumber);
                              print(_dob + _phoneNumber + _name);
                            }
                          },
                          child: Text("Submit")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          color: Colors.yellowAccent[700],
                          onPressed: () {
                            fetchDetails();
                          },
                          child: Text("Fetch details")),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  enterUserDetails(String dob, String name, String phone) {
    final firestore = FirebaseFirestore.instance.collection('users');

    firestore.add({
      "name": name,
      "phone no": phone,
      "dob": dob,
    });
  }

  fetchDetails() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["name"]);
        showAlertDialog(context, doc["name"], doc["phone no"], doc["dob"]);
      });
    });
  }

  showAlertDialog(BuildContext context, String name, String dob, String phone) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hello"),
      content: Text(name + "\n" + dob + "\n" + phone),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
