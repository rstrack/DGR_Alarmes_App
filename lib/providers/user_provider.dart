import 'package:DGR_alarmes/models/user.dart';
import 'package:DGR_alarmes/providers/auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User>((ref) {
  final userStream = ref.watch(streamAuthProvider);
  var user = userStream.value;

  if (user != null) {
    var ref = FirebaseDatabase.instance.ref();
    return ref.child('user/${user.uid}').onValue.map(
        (event) => User.fromJson(event.snapshot.value as Map<String, dynamic>));
  } else {
    return const Stream.empty();
  }
});
