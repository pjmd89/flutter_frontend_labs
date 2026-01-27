import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateUser/updateuser_mutation.dart';
import 'package:labs/src/domain/usecases/User/update_user_usecase.dart';
import 'package:labs/src/domain/usecases/User/read_user_usecase.dart';
import 'package:labs/src/domain/operation/queries/getUsers/getusers_query.dart';
import 'package:labs/src/domain/extensions/edgeuser_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdateUserInput input = UpdateUserInput();
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get loading => _loading;
  bool get error => _error;
  
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }
  
  set error(bool newError) {
    _error = newError;
    notifyListeners();
  }
  
  ViewModel({
    required BuildContext context,
    required String userId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    loadData(userId);
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<void> loadData(String id) async {
    loading = true;
    error = false;
    
    try {
      debugPrint('🔍 Cargando usuario con ID: $id');
      
      // Usar build() para obtener todos los usuarios y filtrar en memoria
      ReadUserUsecase useCase = ReadUserUsecase(
        operation: GetUsersQuery(builder: EdgeUserFieldsBuilder().defaultValues()),
        conn: _gqlConn,
      );
      
      var response = await useCase.build();
      
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      debugPrint('🔍 Response completo: $response');
      
      if (response is EdgeUser && response.edges.isNotEmpty) {
        // Filtrar usuario por ID en memoria
        final users = response.edges.where((user) => user.id == id).toList();
        
        if (users.isNotEmpty) {
          _currentUser = users.first;
          debugPrint('✅ Usuario cargado: ${_currentUser!.firstName} ${_currentUser!.lastName}');
          
          // Prellenar input con datos existentes
          input.id = _currentUser!.id;
          input.firstName = _currentUser!.firstName;
          input.lastName = _currentUser!.lastName;
          input.email = _currentUser!.email;
        } else {
          debugPrint('⚠️ No se encontró usuario con ID: $id en la lista');
          error = true;
          
        }
      } else if (response is EdgeUser && response.edges.isEmpty) {
        debugPrint('⚠️ EdgeUser sin datos - edges está vacío');
        error = true;
        
      } else {
        debugPrint('⚠️ Response no es EdgeUser. Tipo: ${response.runtimeType}');
        error = true;
       
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadData: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      
     
    } finally {
      loading = false;
    }
  }
  
  Future<bool> update() async {
    bool isError = true;
    loading = true;

    UpdateUserUsecase useCase = UpdateUserUsecase(
      operation: UpdateUserMutation(builder: UserFieldsBuilder()),
      conn: _gqlConn,
    );

    try {
      debugPrint('🔄 Actualizando usuario: ${input.toJson()}');
      
      var response = await useCase.execute(input: input);
 
      if (response is User) {
        isError = false;
        _currentUser = response;
        debugPrint('✅ Usuario actualizado exitosamente - isError: $isError');
      } else {
        debugPrint('⚠️ Response NO es de tipo User. Tipo: ${response.runtimeType}');
        isError = true;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateUser: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
    } finally {
      loading = false;
      debugPrint('🏁 Finalizando update - isError: $isError');
    }

    return isError;
  }
}
