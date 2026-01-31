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
    User? user,
    String? userId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    
    if (user != null) {
      // Opción A (recomendada): Objeto completo disponible inmediatamente
      debugPrint('\n✅ ========== Opción A: Usuario prellenado ==========');
      _currentUser = user;
      _prellenarInput(user);
      loading = false;
      debugPrint('========================================\n');
    } else if (userId != null) {
      // Opción B: Cargar desde servidor
      debugPrint('\n⚠️ ========== Opción B: Cargando desde servidor ==========');
      loadData(userId);
    } else {
      debugPrint('\n❌ ERROR: Ni user ni userId fueron proporcionados');
      error = true;
      loading = false;
    }
  }
  
  void _prellenarInput(User user) {
    debugPrint('📝 Prellenando input con datos existentes...');
    input.id = user.id;
    input.firstName = user.firstName;
    input.lastName = user.lastName;
    input.email = user.email;
    
    debugPrint('✅ Input prellenado:');
    debugPrint('   - id: ${input.id}');
    debugPrint('   - firstName: ${input.firstName}');
    debugPrint('   - lastName: ${input.lastName}');
    debugPrint('   - email: ${input.email}');
  }
  
  AppLocalizations get l10n => AppLocalizations.of(_context)!;
  
  Future<void> loadData(String id) async {
    debugPrint('\n🚀 ========== INICIO loadData ==========');
    debugPrint('🔍 ID buscado: "$id"');
    debugPrint('🔍 Tipo de ID: ${id.runtimeType}');
    debugPrint('🔍 Longitud ID: ${id.length}');
    
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
      
      debugPrint('\n📦 ========== RESPONSE RECIBIDA ==========');
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      debugPrint('🔍 Response es EdgeUser: ${response is EdgeUser}');
      
      if (response is EdgeUser) {
        debugPrint('📊 Cantidad de edges: ${response.edges.length}');
        debugPrint('🔍 Edges está vacío: ${response.edges.isEmpty}');
        
        if (response.edges.isNotEmpty) {
          debugPrint('\n👥 ========== USUARIOS EN EDGES ==========');
          for (int i = 0; i < response.edges.length; i++) {
            final user = response.edges[i];
            debugPrint('Usuario [$i]:');
            debugPrint('  - ID: "${user.id}"');
            debugPrint('  - Tipo ID: ${user.id.runtimeType}');
            debugPrint('  - Longitud ID: ${user.id.length}');
            debugPrint('  - Nombre: ${user.firstName} ${user.lastName}');
            debugPrint('  - Email: ${user.email}');
            debugPrint('  - Role: ${user.role}');
            debugPrint('  - ¿Coincide con ID buscado? ${user.id == id}');
            debugPrint('  - ¿IDs idénticos byte a byte? ${user.id.codeUnits == id.codeUnits}');
          }
        }
      }
      
      if (response is EdgeUser && response.edges.isNotEmpty) {
        debugPrint('\n🔎 ========== FILTRANDO USUARIO ==========');
        
        // Filtrar usuario por ID en memoria
        final users = response.edges.where((user) {
          final matches = user.id == id;
          debugPrint('Comparando: "${user.id}" == "$id" → $matches');
          return matches;
        }).toList();
        
        debugPrint('🔍 Usuarios encontrados después del filtro: ${users.length}');
        
        if (users.isNotEmpty) {
          _currentUser = users.first;
          debugPrint('\n✅ ========== USUARIO ENCONTRADO ==========');
          debugPrint('✅ ID: ${_currentUser!.id}');
          debugPrint('✅ Nombre: ${_currentUser!.firstName} ${_currentUser!.lastName}');
          debugPrint('✅ Email: ${_currentUser!.email}');
          debugPrint('✅ Role: ${_currentUser!.role}');
          
          // Prellenar input con datos existentes
          _prellenarInput(_currentUser!);
        } else {
          debugPrint('\n❌ ========== USUARIO NO ENCONTRADO ==========');
          debugPrint('❌ ID buscado: "$id"');
          debugPrint('❌ Total de usuarios en lista: ${response.edges.length}');
          debugPrint('❌ IDs disponibles en la lista:');
          for (var user in response.edges) {
            debugPrint('   - "${user.id}" (${user.firstName} ${user.lastName})');
          }
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
      debugPrint('\n💥 ========== ERROR EN LOADDATA ==========');
      debugPrint('💥 Error: $e');
      debugPrint('💥 Tipo de error: ${e.runtimeType}');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
    } finally {
      loading = false;
      debugPrint('\n🏁 ========== FIN loadData ==========');
      debugPrint('🏁 loading: $_loading');
      debugPrint('🏁 error: $_error');
      debugPrint('🏁 currentUser != null: ${_currentUser != null}');
      if (_currentUser != null) {
        debugPrint('🏁 currentUser.id: ${_currentUser!.id}');
      }
      debugPrint('========================================\n');
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
