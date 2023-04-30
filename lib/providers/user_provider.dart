import 'package:DGR_alarmes/models/user.dart';
import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User>((ref) {
  final userStream = ref.watch(streamAuthProvider);
  var user = userStream.value;
  try {
    if (user != null) {
      var ref = FirebaseDatabase.instance.ref();
      return ref.child('user/${user.uid}').onValue.map((event) {
        return User(
            id: user.uid,
            email: (event.snapshot.value as Map)['email'],
            name: (event.snapshot.value as Map)['name']);
      });
    } else {
      return const Stream.empty();
    }
  } catch (e) {
    return const Stream.empty();
  }
});
