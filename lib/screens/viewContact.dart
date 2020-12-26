import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_realtime_database/Screens/editContact.dart';
// import 'package:firebase_realtime_database/model/contact.dart';
import './editContact.dart';
import '../model/contact.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  final String id;
  ViewContact(this.id);
  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String id;
  Contact _contact;
  bool isLoading = true;
  _ViewContactState(this.id);

  getContact(id) async {
    _databaseReference.child(id).onValue.listen((event) {
      setState(() {
        _contact = Contact.fromSnap(event.snapshot);
        isLoading = false;
      });
    });
  }

  callAction(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Can't call on $number";
    }
  }

  msgAction(String number) async {
    String url = "sms:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Can't send sms to $number";
    }
  }

  navigateToLastScreen() {
    Navigator.pop(context);
  }

  navigateToEditScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditContact(id);
    }));
  }

  deleteContact() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    //error
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () async {
                    //error
                    Navigator.pop(context);
                    await _databaseReference.child(id).remove();
                    navigateToLastScreen();
                  },
                  child: Text('Yes')),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }

  @override
  Widget build(BuildContext context) {
    // wrap screen in WillPopScreen widget
    return Scaffold(
      appBar: AppBar(
        title: Text("View Contact"),
        centerTitle: true,
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  // header text container
                  Container(
                      height: 200.0,
                      child: Image(
                        //
                        image: _contact.photoUrl == "empty"
                            ? AssetImage("images/logo.png")
                            : NetworkImage(_contact.photoUrl),
                        fit: BoxFit.contain,
                      )),
                  //name
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              "${_contact.firstName} ${_contact.lastName}",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // phone
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        //width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _contact.phone,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // email
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _contact.email,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // address
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                              _contact.address,
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        )),
                  ),
                  // call and sms
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.phone),
                              color: Colors.red,
                              onPressed: () {
                                callAction(_contact.phone);
                              },
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.message),
                              color: Colors.red,
                              onPressed: () {
                                msgAction(_contact.phone);
                              },
                            )
                          ],
                        )),
                  ),
                  // edit and delete
                  Card(
                    elevation: 2.0,
                    child: Container(
                        margin: EdgeInsets.all(20.0),
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.edit),
                              color: Colors.red,
                              onPressed: () {
                                navigateToEditScreen(id);
                              },
                            ),
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteContact();
                              },
                            )
                          ],
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
