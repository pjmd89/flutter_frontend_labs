import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/l10n/app_localizations.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/mutations/updateUser/updateuser_mutation.dart';
import 'package:labs/src/domain/usecases/User/update_user_usecase.dart';
import 'package:labs/src/domain/usecases/User/read_user_usecase.dart';
import 'package:labs/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import 'package:labs/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;
  bool _loading = false;
  bool _error = false;
  
  final UpdateUserInput input = UpdateUserInput();
  LabMembershipInfo? _currentMembership;
  
  LabMembershipInfo? get currentMembership => _currentMembership;
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
    LabMembershipInfo? membership,
    String? membershipId,
  }) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    
    if (membership != null) {
      // Opción A (recomendada): Objeto completo disponible inmediatamente
      debugPrint('\n✅ ========== Opción A: Membership prellenado ==========');
      _currentMembership = membership;
      _prellenarInput(membership);
      loading = false;
      debugPrint('========================================\n');
    } else if (membershipId != null) {
      // Opción B: Cargar desde servidor
      debugPrint('\n⚠️ ========== Opción B: Cargando desde servidor ==========');
      loadData(membershipId);
    } else {
      debugPrint('\n❌ ERROR: Ni membership ni membershipId fueron proporcionados');
      error = true;
      loading = false;
    }
  }
  
  void _prellenarInput(LabMembershipInfo membership) {
    debugPrint('📝 Prellenando input con datos existentes...');
    input.id = membership.member?.id ?? '';
    input.firstName = membership.member?.firstName ?? '';
    input.lastName = membership.member?.lastName ?? '';
    input.email = membership.member?.email ?? '';
    
    debugPrint('✅ Input prellenado:');
    debugPrint('   - id: ${input.id}');
    debugPrint('   - firstName: ${input.firstName}');
    debugPrint('   - lastName: ${input.lastName}');
    debugPrint('   - email: ${input.email}');
    debugPrint('   - role: ${membership.role}');
    debugPrint('   - fee: ${membership.laboratory?.company?.owner?.fee}');
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
      debugPrint('🔍 Cargando membership con ID: $id');
      
      // Usar build() para obtener todos los memberships y filtrar en memoria
      ReadUserUsecase useCase = ReadUserUsecase(
        operation: GetLabMembershipsQuery(builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues()),
        conn: _gqlConn,
      );
      
      var response = await useCase.build();
      
      debugPrint('\n📦 ========== RESPONSE RECIBIDA ==========');
      debugPrint('🔍 Tipo de response: ${response.runtimeType}');
      debugPrint('🔍 Response es EdgeLabMembershipInfo: ${response is EdgeLabMembershipInfo}');
      
      if (response is EdgeLabMembershipInfo) {
        debugPrint('📊 Cantidad de edges: ${response.edges.length}');
        debugPrint('🔍 Edges está vacío: ${response.edges.isEmpty}');
        
        if (response.edges.isNotEmpty) {
          debugPrint('\n👥 ========== MEMBERSHIPS EN EDGES ==========');
          for (int i = 0; i < response.edges.length; i++) {
            final membership = response.edges[i];
            debugPrint('Membership [$i]:');
            debugPrint('  - ID: "${membership.id}"');
            debugPrint('  - Member ID: "${membership.member?.id}"');
            debugPrint('  - Nombre: ${membership.member?.firstName} ${membership.member?.lastName}');
            debugPrint('  - Role: ${membership.role}');
            debugPrint('  - Fee: ${membership.laboratory?.company?.owner?.fee}');
            debugPrint('  - ¿Coincide con ID buscado? ${membership.id == id}');
          }
        }
      }
      
      if (response is EdgeLabMembershipInfo && response.edges.isNotEmpty) {
        debugPrint('\n🔎 ========== FILTRANDO MEMBERSHIP ==========');
        
        // Filtrar membership por ID en memoria
        final memberships = response.edges.where((membership) {
          final matches = membership.id == id;
          debugPrint('Comparando: "${membership.id}" == "$id" → $matches');
          return matches;
        }).toList();
        
        debugPrint('🔍 Memberships encontrados después del filtro: ${memberships.length}');
        
        if (memberships.isNotEmpty) {
          _currentMembership = memberships.first;
          debugPrint('\n✅ ========== MEMBERSHIP ENCONTRADO ==========');
          debugPrint('✅ ID: ${_currentMembership!.id}');
          debugPrint('✅ Member: ${_currentMembership!.member?.firstName} ${_currentMembership!.member?.lastName}');
          debugPrint('✅ Role: ${_currentMembership!.role}');
          debugPrint('✅ Fee: ${_currentMembership!.laboratory?.company?.owner?.fee}');
          
          // Prellenar input con datos existentes
          _prellenarInput(_currentMembership!);
        } else {
          debugPrint('\n❌ ========== MEMBERSHIP NO ENCONTRADO ==========');
          debugPrint('❌ ID buscado: "$id"');
          debugPrint('❌ Total de memberships en lista: ${response.edges.length}');
          debugPrint('❌ IDs disponibles en la lista:');
          for (var membership in response.edges) {
            debugPrint('   - "${membership.id}" (${membership.member?.firstName})');
          }
          error = true;
        }
      } else if (response is EdgeLabMembershipInfo && response.edges.isEmpty) {
        debugPrint('⚠️ EdgeLabMembershipInfo sin datos - edges está vacío');
        error = true;
        
      } else {
        debugPrint('⚠️ Response no es EdgeLabMembershipInfo. Tipo: ${response.runtimeType}');
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
      debugPrint('🏁 currentMembership != null: ${_currentMembership != null}');
      if (_currentMembership != null) {
        debugPrint('🏁 currentMembership.id: ${_currentMembership!.id}');
        debugPrint('🏁 member.id: ${_currentMembership!.member?.id}');
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
        // Actualizar member dentro de currentMembership
        if (_currentMembership != null) {
          _currentMembership = LabMembershipInfo(
            id: _currentMembership!.id,
            role: _currentMembership!.role,
            member: response,
            laboratory: _currentMembership!.laboratory,
            access: _currentMembership!.access,
            created: _currentMembership!.created,
            updated: _currentMembership!.updated,
          );
        }
        debugPrint('✅ Usuario actualizado exitosamente - isError: $isError');
        
        _errorService.showError(
          message: l10n.thingUpdatedSuccessfully(l10n.user),
          type: ErrorType.success,
        );
      } else {
        debugPrint('⚠️ Response NO es de tipo User. Tipo: ${response.runtimeType}');
        isError = true;
        
        _errorService.showError(
          message: 'Error inesperado al actualizar usuario',
          type: ErrorType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en updateUser: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      isError = true;
      
      _errorService.showError(
        message: 'Error al actualizar usuario: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
      debugPrint('🏁 Finalizando update - isError: $isError');
    }

    return isError;
  }
}
