import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getLoggedUser/getloggeduser_query.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/extensions/user_logged_builder/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/usecases/User/read_user_logged_usecase.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/presentation/providers/auth_notifier.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = true;
  bool _error = false;
  late GqlConn _gqlConn;
  final BuildContext _context;
  final GetLoggedUserQuery _loggedQuery =  GetLoggedUserQuery(
    builder: LoggedUserFieldsBuilder().defaultValues()
  );
  bool get loading => _loading;
  bool get error => _error;

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  set error(bool value) {
    _error = value;
    notifyListeners();
  }
  ViewModel(
    {required BuildContext context}
  ) : _context = context{
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
  }

  setLoginUser(LoggedUser loggedUser) async{
    final laboratoryNotifier = _context.read<LaboratoryNotifier>();
    final authNotifier = _context.read<AuthNotifier>();
    
    // Verificar si es usuario ROOT o ADMIN
    final isRootOrAdmin = loggedUser.user?.role == Role.rOOT || loggedUser.user?.role == Role.aDMIN;
    
    if (isRootOrAdmin) {
      // ROOT/ADMIN: NO ejecutar setCurrentLaboratory, entrar directamente sin laboratorio
      debugPrint('🔑 Usuario ROOT/ADMIN detectado - Acceso sin laboratorio');
      await authNotifier.signIn(
        user: loggedUser.user!,
        userIsLabOwner: loggedUser.userIsLabOwner,
        labRole: loggedUser.labRole,
      );
      debugPrint('✅ SignIn completado para ROOT/ADMIN');
      return;
    }
    
    // Para usuarios normales: continuar con el flujo de selección de laboratorio
    Laboratory? laboratoryToSelect;
    
    // Si el LoggedUser tiene un currentLaboratory, usarlo
    if (loggedUser.currentLaboratory != null) {
      laboratoryToSelect = loggedUser.currentLaboratory;
      debugPrint('📌 LoggedUser tiene currentLaboratory: ${laboratoryToSelect!.company?.name}');
    } else {
      // Si NO tiene currentLaboratory, obtener laboratorios según el rol del usuario
      debugPrint('⚠️ LoggedUser NO tiene currentLaboratory - obteniendo laboratorios disponibles');
      try {
        // readWithoutPaginate() del backend ya filtra automáticamente por membresía del usuario
        // Solo retorna los laboratorios donde el usuario autenticado es miembro
        final laboratoriesResponse = await ReadLaboratoryUsecase(
          operation: GetLaboratoriesQuery(
            builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
          ),
          conn: _gqlConn,
        ).readWithoutPaginate();
        
        if (laboratoriesResponse is EdgeLaboratory && laboratoriesResponse.edges.isNotEmpty) {
          laboratoryToSelect = laboratoriesResponse.edges.first;
          debugPrint('✅ Primer laboratorio obtenido: ${laboratoryToSelect.company?.name}');
          debugPrint('   Total laboratorios del usuario: ${laboratoriesResponse.edges.length}');
        } else {
          debugPrint('❌ No se encontraron laboratorios disponibles para este usuario');
        }
      } catch (e, stackTrace) {
        debugPrint('💥 Error obteniendo laboratorios: $e');
        debugPrint('📍 StackTrace: $stackTrace');
      }
    }
    
    // Ejecutar la mutación setCurrentLaboratory con el laboratorio seleccionado PRIMERO
    LoggedUser? updatedLoggedUser;
    if (laboratoryToSelect != null) {
      try {
        debugPrint('🚀 Ejecutando setCurrentLaboratory con: ${laboratoryToSelect.company?.name}');
        await laboratoryNotifier.selectLaboratory(
          laboratoryToSelect,
          _context,
          shouldNavigate: false,
        );
        
        // Obtener el LoggedUser actualizado desde el laboratoryNotifier
        updatedLoggedUser = laboratoryNotifier.loggedUser;
        debugPrint('✅ Laboratorio seleccionado y mutación ejecutada exitosamente');
        debugPrint('   LabRole actualizado: ${updatedLoggedUser?.labRole}');
        debugPrint('   UserIsLabOwner actualizado: ${updatedLoggedUser?.userIsLabOwner}');
      } catch (e, stackTrace) {
        debugPrint('💥 Error ejecutando setCurrentLaboratory después del login: $e');
        debugPrint('📍 StackTrace: $stackTrace');
      }
    }
    
    // Ahora hacer signIn con los datos actualizados (si tenemos updatedLoggedUser, usarlo)
    final finalLoggedUser = updatedLoggedUser ?? loggedUser;
    await authNotifier.signIn(
      user: finalLoggedUser.user!,
      userIsLabOwner: finalLoggedUser.userIsLabOwner,
      labRole: finalLoggedUser.labRole,
    );
    
    debugPrint('✅ SignIn completado con labRole: ${finalLoggedUser.labRole}');
  }
  Future<LoggedUser?> loggedUser() async {
    loading = true;
    error = false;

    try {
      final response = await ReadUserLoggedUsecase(
        operation: _loggedQuery,
        conn: _gqlConn,
      ).build();

      debugPrint('🔍 Response type: ${response.runtimeType}');

      // Si la respuesta es ErrorReturned, el ErrorManager ya mostró el mensaje
      if (response.runtimeType.toString() == 'ErrorReturned') {
        debugPrint('❌ Response es ErrorReturned - error controlado del backend');
        error = true;
        return null;
      }

      // Verificar que sea LoggedUser antes de retornar
      if (response is LoggedUser) {
        return response;
      } else {
        debugPrint('💥 Tipo de respuesta inesperado: ${response.runtimeType}');
        error = true;
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loggedUser: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      return null;
    } finally {
      loading = false;
    }
  }

  read(Operation operation) async{
    _gqlConn.operation(operation: operation);
  }


}
