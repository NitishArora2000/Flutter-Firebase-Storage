import 'package:flutter/material.dart';
import 'addContact.dart';
import 'editContact.dart';
import 'viewContact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  navigateToAddScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddContact()));
  }

  navigateToViewScreen(id) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewContact(id);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact App"),centerTitle: true,),
      body: Container(
        child: FirebaseAnimatedList(
            query: _databaseReference,
            itemBuilder:
                (context, snapshot, Animation<double> animation, index) {
              return GestureDetector(
                onTap: () => navigateToViewScreen(snapshot.key),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: snapshot.value['photoUrl'] == 'empty'
                                        ? AssetImage('images/logo.png')
                                        : NetworkImage(
                                            snapshot.value['photoUrl'])))),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.value['firstName']} ${snapshot.value['lastName']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text('${snapshot.value['phone']}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddScreen,
      ),
    );
  }
}
