import 'package:firebase_database/firebase_database.dart';
//import 'package:firebase_realtime_database/model/contact.dart';
import '../model/contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _address = '';
  String _phone = '';
  String _photoUrl = 'empty';

  navigateToLastScreen(context) {
    Navigator.of(context).pop();
  }

  //error: context
  saveContact(context) async {
    if (_firstName.isNotEmpty &&
        _lastName.isNotEmpty &&
        _email.isNotEmpty &&
        _phone.isNotEmpty &&
        _address.isNotEmpty &&
        _photoUrl.isNotEmpty) {
      Contact contact = Contact(this._firstName, this._lastName, this._email,
          this._phone, this._address, this._photoUrl);

      await _databaseReference.push().set(contact.toJson());

      navigateToLastScreen(context);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Attention!'),
              content: Text('All fields are required'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }
  }

  Future pickImage() async {
    // ignore: deprecated_member_use
    File file = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200.0, maxWidth: 200.0);
    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }

  uploadImage(file, fileName) {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    storageReference.putFile(file).onComplete.then((value) async {
      String url = await value.ref.getDownloadURL();
      setState(() {
        _photoUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact'),
        centerTitle: true,
      ),
      body: Container(
        // margin: ,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: pickImage, // potention error
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _photoUrl == 'empty'
                            ? AssetImage('images/logo.png')
                            : NetworkImage(_photoUrl),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //first name
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //last name
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //email
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //phone
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //address
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            //save
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.purple[300],
                  onPressed: () {
                    saveContact(context);
                  },
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
