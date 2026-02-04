import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:labs/src/domain/entities/types/laboratory/laboratory_model.dart';
import 'package:labs/src/domain/entities/types/loggeduser/loggeduser_model.dart';
import 'package:labs/src/domain/entities/enums/labmemberrole_enum.dart';
import 'package:labs/src/domain/usecases/Laboratory/set_current_laboratory_usecase.dart';
import 'package:labs/src/domain/operation/mutations/setCurrentLaboratory/setcurrentlaboratory_mutation.dart';
import 'package:labs/src/domain/extensions/user_logged_builder/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:agile_front/agile_front.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Provider para manejar el laboratorio seleccionado actualmente
class LaboratoryNotifier extends ChangeNotifier {
  Laboratory? _selectedLaboratory;
  LoggedUser? _loggedUser;
  final GqlConn? _gqlConn;

  Laboratory? get selectedLaboratory => _selectedLaboratory;
  LoggedUser? get loggedUser => _loggedUser;
  String get laboratoryName => _selectedLaboratory?.company?.name ?? 'Labs';
  bool get hasLaboratory => _selectedLaboratory != null;

  LaboratoryNotifier({GqlConn? gqlConn}) : _gqlConn = gqlConn {
    _loadSelectedLaboratory();
  }

  /// Cargar laboratorio seleccionado desde SharedPreferences
  Future<void> _loadSelectedLaboratory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final laboratoryJson = prefs.getString('selected_laboratory');
      
      if (laboratoryJson != null) {
        final Map<String, dynamic> json = jsonDecode(laboratoryJson);
        _selectedLaboratory = Laboratory.fromJson(json);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Error loading selected laboratory: $e');
      }
    }
  }

  /// Seleccionar un nuevo laboratorio y ejecutar mutación setCurrentLaboratory
  /// 
  /// Parámetros:
  /// - [laboratory]: El laboratorio a seleccionar
  /// - [context]: BuildContext para acceder a providers y detectar la ruta actual
  /// - [shouldNavigate]: Si es true, navegará a la ruta según el labRole (default: true)
  /// - [onLaboratoryChanged]: Callback opcional que se ejecuta después de cambiar el laboratorio
  ///   Si no se proporciona, se intentará refrescar automáticamente según la ruta actual
  Future<void> selectLaboratory(
    Laboratory laboratory, 
    BuildContext context, {
    bool shouldNavigate = true,
    Future<void> Function()? onLaboratoryChanged,
  }) async {
    _selectedLaboratory = laboratory;
    
    // Guardar en SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final laboratoryJson = jsonEncode(laboratory.toJson());
      await prefs.setString('selected_laboratory', laboratoryJson);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Error saving selected laboratory: $e');
      }
    }
    
    // Ejecutar mutación setCurrentLaboratory si tenemos gqlConn
    if (_gqlConn != null) {
      try {
        debugPrint('🚀 Ejecutando mutación setCurrentLaboratory para laboratoryId: ${laboratory.id}');
        
        final useCase = SetCurrentLaboratoryUsecase(
          operation: SetCurrentLaboratoryMutation(
            builder: LoggedUserFieldsBuilder().defaultValues(),
          ),
          conn: _gqlConn,
        );

        final loggedUser = await useCase.execute(laboratoryId: laboratory.id);
        
        if (loggedUser != null && context.mounted) {
          _loggedUser = loggedUser;
          
          // Actualizar labRole en AuthNotifier
          final authNotifier = context.read<AuthNotifier>();
          await authNotifier.updateLabRole(
            loggedUser.labRole,
            loggedUser.userIsLabOwner,
          );
          
          debugPrint('✅ setCurrentLaboratory ejecutado exitosamente');
          debugPrint('   CurrentLab: ${loggedUser.currentLaboratory?.company?.name ?? 'N/A'}');
          debugPrint('   LabRole: ${loggedUser.labRole}');
          debugPrint('   UserIsLabOwner: ${loggedUser.userIsLabOwner}');
          
          // Navegar a la ruta inicial correspondiente según el labRole (solo si shouldNavigate es true)
          if (shouldNavigate && context.mounted) {
            String initialRoute;
            switch (loggedUser.labRole) {
              case LabMemberRole.oWNER:
                initialRoute = '/home';
                debugPrint('🧭 Navegando a ruta de OWNER: $initialRoute');
                break;
              case LabMemberRole.bIOANALYST:
                initialRoute = '/evaluationpackage';
                debugPrint('🧭 Navegando a ruta de BIOANALYST: $initialRoute');
                break;
              case LabMemberRole.tECHNICIAN:
                initialRoute = '/exam';
                debugPrint('🧭 Navegando a ruta de TECHNICIAN: $initialRoute');
                break;
              case LabMemberRole.bILLING:
                initialRoute = '/billing';
                debugPrint('🧭 Navegando a ruta de BILLING: $initialRoute');
                break;
              default:
                initialRoute = '/dashboard';
                debugPrint('🧭 Navegando a ruta por defecto: $initialRoute');
            }
            context.go(initialRoute);
          }
          
          // Ejecutar callback si existe
          if (onLaboratoryChanged != null) {
            debugPrint('🔄 Ejecutando callback onLaboratoryChanged...');
            await onLaboratoryChanged();
          }
        }
      } catch (e, stackTrace) {
        debugPrint('💥 Error ejecutando setCurrentLaboratory: $e');
        debugPrint('📍 StackTrace: $stackTrace');
        // No lanzamos el error para que la UI no se bloquee
      }
    } else {
      debugPrint('⚠️ GqlConn no disponible, no se ejecutará la mutación');
    }
    
    notifyListeners();
  }

  /// Limpiar laboratorio seleccionado
  Future<void> clearLaboratory() async {
    _selectedLaboratory = null;
    _loggedUser = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('selected_laboratory');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Error clearing selected laboratory: $e');
      }
    }
    
    notifyListeners();
  }

  /// Inicializar laboratorio por defecto después del login
  /// 
  /// Este método se usa cuando el usuario inicia sesión y el backend ya
  /// retorna un currentLaboratory. Solo guarda el laboratorio localmente
  /// sin ejecutar la mutación setCurrentLaboratory porque ya fue ejecutada.
  /// 
  /// Parámetros:
  /// - [laboratory]: El laboratorio a establecer como seleccionado
  /// - [loggedUser]: El LoggedUser que contiene la información del usuario y laboratorio
  Future<void> initializeDefaultLaboratory(
    Laboratory laboratory, 
    LoggedUser loggedUser,
  ) async {
    _selectedLaboratory = laboratory;
    _loggedUser = loggedUser;
    
    // Guardar en SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final laboratoryJson = jsonEncode(laboratory.toJson());
      await prefs.setString('selected_laboratory', laboratoryJson);
      debugPrint('💾 Laboratorio guardado en SharedPreferences: ${laboratory.company?.name}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('💥 Error saving selected laboratory: $e');
      }
    }
    
    notifyListeners();
  }
}
