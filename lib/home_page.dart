import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/user_model.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var auth1=FirebaseFirestore.instance.collection('users');
  var userRef = Firestore.instance.collection("users").snapshots();
  UserModel _currentUser;

  String _uid;
  String _username;
  String _email;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    //getData();
  }
 /* Future<void> getData() async {
    // Get docs from collection reference
   // QuerySnapshot querySnapshot = await userRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    print("my data is ${allData}");
  }*/

  getCurrentUser() async {
    UserModel currentUser = await context
        .read<AuthenticationService>()
        .getUserFromDB(uid: auth.currentUser.uid);

   setState(() {
     _currentUser = currentUser;
   });
   print('all users is$userRef');

    print("${_currentUser.username}");

    setState(() {
      _uid = _currentUser.uid;
      _username = _currentUser.username;
      _email = _currentUser.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
      ),
      body:StreamBuilder(
        stream: userRef,
        builder: (context,snapshot){
          if(!snapshot.hasData)
            return CircularProgressIndicator();
          return ListView.builder(itemCount: snapshot.data.documents.length,
          itemBuilder: (context,int index){
            return Column(
              children: [
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    print(index);
                  },
                    child: Text(snapshot.data.documents[index]["username"])),
                SizedBox(height: 50,)
              ],
            );
          },);
        },
      )
    );
  }
}
