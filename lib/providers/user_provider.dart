// ignore_for_file: prefer_final_fields, unused_local_variable

import 'package:DGR_alarmes/dao/user_dao.dart';
import 'package:DGR_alarmes/models/User.dart';
import 'package:flutter/foundation.dart';

import '../models/device.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> _users = [];
  UserDao _userDao = UserDao();

  Future<void> fetchUsers({Device? device}) async {
    _users = await _userDao.loadUsers(device: device);
    notifyListeners();
  }

  Future<void> saveUser(UserModel user) async {
    String key = await _userDao.saveUser(user);
    user.id = key;
    _users.add(user);
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    await _userDao.updateUser(user.id!, user);

    var contains = _users.indexWhere((element) =>
        element.id == user.id); //verificar se retorna indice correto
    _users[contains] = user;
    notifyListeners();
  }

  Future<void> deleteUser(UserModel user) async {
    await _userDao.deleteUser(user.id!);
    _users.removeWhere((element) => element.id == user.id);
    notifyListeners();
  }
}
