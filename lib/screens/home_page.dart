import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userAuth = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var loggedUser = UserModel(id: userAuth.uid, email: userAuth.email.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('DGR Alarmes'),
      ),
      drawer: const MenuDrawer(),
      body: Column(
        children: [
          Center(child: Text('Bem vindo ${loggedUser.email}!')),
          // FutureBuilder(
          //   future: database.getUsersByDevice(idDevice: idDevice),
          //   builder: (context, snapshot) {
          //     if(!snapshot.hasData){
          //       return CircularProgressIndicator(color: Colors.white,);
          //     }
          //     return Flexible(
          //       child: ListView.builder(
          //         itemCount: snapshot.data!.length,
          //         itemBuilder: (context, index) => Center(child: Text("${snapshot.data!.length} | ${snapshot.data!.elementAt(index).name!}")),
          //       ),
          //     );
          //   },
          // )
        ],
      ),
    );
  }
}
