import 'package:flutter/foundation.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/domain/entities/types/user/user_model.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier();

  String? _firstName;
  String? _lastName;
  String? _id;
  Role? _role;

  String get firstName => _firstName ?? '';
  String get fullName => '$_firstName ${_lastName ?? ''}'.trim();
  String get id => _id ?? '';
  Role? get role => _role;
  bool get isAuthenticated => _id != null;
  

  Future<void> signIn({required User user}) async {
    _firstName = user.firstName;
    _lastName = user.lastName;
    _id = user.id;
    _role = user.role;

    notifyListeners();
  }

  Future<void> signOut() async {
    _firstName = null;
    _lastName = null;
    _id = null;
    _role = null;
    notifyListeners();
  }
}
