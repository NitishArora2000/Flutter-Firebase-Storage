import 'package:firebase_database/firebase_database.dart';

class Contact {
  String _id;
  String _firstName;
  String _lastName;
  String _email;
  String _photoUrl;
  String _phone;
  String _address;

  //constructors

  Contact(this._firstName, this._lastName, this._email, this._phone,
      this._address, this._photoUrl);
  Contact.withID(this._id,this._firstName, this._lastName, this._email, this._phone,
      this._address, this._photoUrl);

  //getters

  String get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get email => this._email;
  String get phone => this._phone;
  String get address => this._address;
  String get photoUrl => this._photoUrl;

  //setters
  set firstName(String firstname) {
    _firstName = firstname;
  }

  set lastName(String lastname) {
    _lastName = lastname;
  }

  set phone(String phone) {
    _phone = phone;
  }

  set email(String email) {
    _email = email;
  }

  set address(String add) {
    _address = add;
  }

  set photoUrl(String url) {
    _photoUrl = url;
  }

  Contact.fromSnap(DataSnapshot snapshot) {
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._email = snapshot.value['email'];
    this._photoUrl = snapshot.value['photoUrl'];
    this._phone = snapshot.value['phone'];
    this._address = snapshot.value['address'];
  }

  Map<String, dynamic> toJson(){
    return{
      "firstName" :  _firstName,
      "lastName" : _lastName,
      "phone": _phone,
      "email":_email,
      "address":_address,
      "photoUrl":_photoUrl,
    };
  }
}
