import 'package:flutter/foundation.dart';
import 'package:labs/src/domain/entities/enums/role_enum.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/domain/entities/types/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    _loadUserFromStorage();
  }
  
  String? _firstName;
  String? _lastName;
  String? _id;
  Role? _role;
  bool _userIsLabOwner = false;
  LabMemberRole? _labRole;
  
  String get firstName => _firstName ?? '';
  String get fullName => '$_firstName ${_lastName ?? ''}'.trim();
  String get id => _id ?? '';
  Role? get role => _role;
  bool get userIsLabOwner => _userIsLabOwner;
  LabMemberRole? get labRole => _labRole;
  bool get isAuthenticated => _id != null;

  // Cargar usuario desde SharedPreferences al iniciar
  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _firstName = prefs.getString('user_firstName');
      _lastName = prefs.getString('user_lastName');
      _id = prefs.getString('user_id');
      final roleString = prefs.getString('user_role');
      _userIsLabOwner = prefs.getBool('user_isLabOwner') ?? false;
      final labRoleString = prefs.getString('user_labRole');
      
      if (roleString != null) {
        _role = Role.values.firstWhere(
          (e) => e.toString() == roleString,
          orElse: () => Role.values.first,
        );
      }
      
      if (labRoleString != null) {
        _labRole = LabMemberRole.values.firstWhere(
          (e) => e.toString() == labRoleString,
          orElse: () => LabMemberRole.values.first,
        );
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user from storage: $e');
      }
    }
  }

  Future<void> signIn({required User user, bool userIsLabOwner = false, LabMemberRole? labRole}) async {
    _firstName = user.firstName;
    _lastName = user.lastName;
    _id = user.id;
    _role = user.role;
    _userIsLabOwner = userIsLabOwner;
    _labRole = labRole;
    
    // Guardar en SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_firstName', user.firstName);
      await prefs.setString('user_lastName', user.lastName);
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_role', user.role.toString());
      await prefs.setBool('user_isLabOwner', userIsLabOwner);
      if (labRole != null) {
        await prefs.setString('user_labRole', labRole.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user to storage: $e');
      }
    }
    
    notifyListeners();
  }
  
  // Método para actualizar solo el labRole (cuando cambia de laboratorio)
  Future<void> updateLabRole(LabMemberRole? labRole, bool userIsLabOwner) async {
    _labRole = labRole;
    _userIsLabOwner = userIsLabOwner;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('user_isLabOwner', userIsLabOwner);
      if (labRole != null) {
        await prefs.setString('user_labRole', labRole.toString());
      } else {
        await prefs.remove('user_labRole');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating lab role: $e');
      }
    }
    
    notifyListeners();
  }
  
  Future<void> signOut() async {
    _firstName = null;
    _lastName = null;
    _id = null;
    _role = null;
    _userIsLabOwner = false;
    _labRole = null;
    
    // Limpiar SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_firstName');
      await prefs.remove('user_lastName');
      await prefs.remove('user_id');
      await prefs.remove('user_role');
      await prefs.remove('user_isLabOwner');
      await prefs.remove('user_labRole');
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing user from storage: $e');
      }
    }
    
    notifyListeners();
  }
}
