import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Para jsonEncode en debugging
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/presentation/providers/auth_notifier.dart';
import '/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import '/src/domain/operation/fields_builders/edgelabmembershipinfo_fields_builder.dart';
import '/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import '/src/domain/usecases/LabMembership/read_labmembership_usecase.dart';


class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<LabMembershipInfo>? _membershipList;
  List<LabMembershipInfo>? _originalMembershipList; // Copia original para filtrado
  List<User>? _userList;
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLabMembershipUsecase _readMembershipUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  late bool _isRootUser; // true si es ROOT o ADMIN
  final BuildContext _context;

  // Query con FieldsBuilder configurado para memberships
  final GetLabMembershipsQuery _membershipOperation = GetLabMembershipsQuery(
    builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues(),
  );

  bool get loading => _loading;
  bool get error => _error;
  List<LabMembershipInfo>? get membershipList => _membershipList;
  List<User>? get userList => _userList;
  PageInfo? get pageInfo => _pageInfo;
  bool get isRootUser => _isRootUser; // true si es ROOT o ADMIN

  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set membershipList(List<LabMembershipInfo>? value) {
    _membershipList = value;
    // Guardar copia original cuando se actualizan los datos desde el backend
    if (value != null) {
      _originalMembershipList = List.from(value);
    }
    notifyListeners();
  }
  
  set userList(List<User>? value) {
    _userList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    
    // Detectar si es usuario ROOT o ADMIN
    final authNotifier = _context.read<AuthNotifier>();
    _isRootUser = authNotifier.role == Role.rOOT || authNotifier.role == Role.aDMIN;
    
    debugPrint('🔍 User ViewModel - Es ROOT o ADMIN? $_isRootUser, Rol: ${authNotifier.role}');
    
    // Inicializar usecase de memberships para todos los roles
    _readMembershipUseCase = ReadLabMembershipUsecase(operation: _membershipOperation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado solo si NO es root
    if (!_isRootUser) {
      _laboratoryNotifier.addListener(_onLaboratoryChanged);
    }
    
    _init();
  }
  
  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando membresías...');
    getMemberships();
  }
  
  @override
  void dispose() {
    if (!_isRootUser) {
      _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    }
    super.dispose();
  }

  Future<void> _init() async {
    await getMemberships();
  }

  Future<void> getMemberships() async {
    loading = true;
    error = false;

    try {
      if (_isRootUser) {
        // ROOT/ADMIN: Usar build() sin filtros para obtener TODAS las membresías
        debugPrint('🔍 ROOT/ADMIN: Obteniendo todas las membresías del sistema (sin filtros)');
        
        final response = await _readMembershipUseCase.build();

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
          userList = null; // Limpiar userList, ahora usamos membershipList
          
          debugPrint('✅ Total membresías obtenidas: ${response.edges.length}');
          if (response.edges.isNotEmpty) {
            debugPrint('📋 Ejemplos de usuarios en este laboratorio:');
            for (var i = 0; i < response.edges.length.clamp(0, 3); i++) {
              final membership = response.edges[i];
              final user = membership.member;
              debugPrint('   - ${user?.firstName} ${user?.lastName} (${user?.email})');
            }
          }
        }
      } else {
        // Otros usuarios: filtrar por laboratorio seleccionado
        final selectedLaboratory = _laboratoryNotifier.selectedLaboratory;
        
        if (selectedLaboratory == null) {
          debugPrint('⚠️ No hay laboratorio seleccionado');
          membershipList = [];
          userList = [];
          loading = false;
          return;
        }

        final searchInputs = [
          SearchInput(
            field: 'laboratory',
            value: [
              ValueInput(
                value: selectedLaboratory.id,
                operator: OperatorEnum.eq,
                kind: KindEnum.iD,
              )
            ]
          )
        ];
        
        debugPrint('🔍 Buscando membresías del laboratorio: ${selectedLaboratory.id}');

        final response = await _readMembershipUseCase.search(searchInputs, null);

        if (response is EdgeLabMembershipInfo) {
          membershipList = response.edges;
          pageInfo = response.pageInfo;
          userList = null;
          
          debugPrint('✅ Membresías obtenidas: ${response.edges.length}');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getMemberships: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      membershipList = [];
      userList = [];

      // Mostrar error al usuario
     
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    // Si no hay filtros de búsqueda, recargar datos normales
    if (searchInputs.isEmpty) {
      await getMemberships();
      return;
    }
    
    // Si hay memberships cargadas, filtrar del lado del cliente
    if (_originalMembershipList != null && _originalMembershipList!.isNotEmpty) {
      debugPrint('🔍 Filtrando ${_originalMembershipList!.length} membresías del lado del cliente');
      
      // Extraer el texto de búsqueda del primer SearchInput
      String searchText = '';
      if (searchInputs.isNotEmpty && 
          searchInputs[0].value != null && 
          searchInputs[0].value!.isNotEmpty &&
          searchInputs[0].value![0]?.value != null) {
        searchText = searchInputs[0].value![0]!.value.toString().toLowerCase();
      }
      
      debugPrint('🔍 Texto de búsqueda: "$searchText"');
      
      if (searchText.isEmpty) {
        // Sin texto, mostrar todos
        membershipList = _originalMembershipList;
        return;
      }
      
      // Filtrar membresías por nombre, apellido o email del usuario
      final filtered = _originalMembershipList!.where((membership) {
        final user = membership.member;
        if (user == null) return false;
        
        final firstName = user.firstName?.toLowerCase() ?? '';
        final lastName = user.lastName?.toLowerCase() ?? '';
        final email = user.email?.toLowerCase() ?? '';
        
        return firstName.contains(searchText) ||
               lastName.contains(searchText) ||
               email.contains(searchText);
      }).toList();
      
      debugPrint('✅ Resultados filtrados: ${filtered.length}');
      
      // Actualizar la lista mostrada
      membershipList = filtered;
      
      // Actualizar pageInfo para reflejar los resultados filtrados
      if (_pageInfo != null) {
        pageInfo = PageInfo(
          total: filtered.length,
          page: 1,
          pages: (filtered.length / (_pageInfo!.split > 0 ? _pageInfo!.split : 10)).ceil(),
          split: _pageInfo!.split,
        );
      }
      
      notifyListeners();
      return;
    }
    
    // Si no hay datos cargados, intentar búsqueda en el backend
    // (este código es el fallback, normalmente no debería ejecutarse)
    loading = true;
    error = false;

    try {
      
      // Validar y corregir pageInfo antes de usarlo
      PageInfo? validPageInfo = _pageInfo;
      if (validPageInfo != null && validPageInfo.split <= 0) {
        validPageInfo = PageInfo(
          total: validPageInfo.total,
          page: validPageInfo.page,
          pages: validPageInfo.pages,
          split: 10,
        );
      }
      
      // Preparar filtros
      List<SearchInput> finalSearchInputs = [];
      
      // Si hay múltiples campos de búsqueda, agruparlos con OR
      if (searchInputs.length > 1) {
        // Crear un único SearchInput con lógica OR para los campos de búsqueda
        final orSearchInput = SearchInput(
          or: searchInputs,
        );
        finalSearchInputs.add(orSearchInput);
      } else if (searchInputs.length == 1) {
        finalSearchInputs.add(searchInputs[0]);
      }
      
      // Si NO es ROOT/ADMIN, agregar filtro del laboratorio seleccionado
      if (!_isRootUser) {
        final selectedLaboratory = _laboratoryNotifier.selectedLaboratory;
        
        if (selectedLaboratory == null) {
          debugPrint('⚠️ No hay laboratorio seleccionado para búsqueda');
          membershipList = [];
          userList = [];
          loading = false;
          return;
        }
        
        // Agregar filtro de laboratorio a los searchInputs
        finalSearchInputs.add(
          SearchInput(
            field: 'laboratory',
            value: [
              ValueInput(
                value: selectedLaboratory.id,
                operator: OperatorEnum.eq,
                kind: KindEnum.iD,
              )
            ]
          )
        );
        
        debugPrint('🔍 Búsqueda con filtro de laboratorio: ${selectedLaboratory.id}');
      }
      
      // Debug: Mostrar qué se está enviando
      debugPrint('🔍 Search Inputs que se enviarán:');
      for (var input in finalSearchInputs) {
        debugPrint('   Field: ${input.field}');
        if (input.value != null) {
          for (var value in input.value!) {
            debugPrint('   Value: ${value?.value}, Kind: ${value?.kind}, Operator: ${value?.operator}');
          }
        }
        if (input.or != null) {
          debugPrint('   OR logic with ${input.or!.length} conditions:');
          for (var orInput in input.or!) {
            debugPrint('      - Field: ${orInput?.field}');
            if (orInput?.value != null) {
              for (var val in orInput!.value!) {
                debugPrint('        Value: ${val?.value}');
              }
            }
          }
        }
      }
      
      // Debug: Mostrar JSON completo
      debugPrint('📤 JSON que se enviará:');
      try {
        final jsonList = finalSearchInputs.map((e) => e.toJson()).toList();
        debugPrint('   ${jsonEncode(jsonList)}');
      } catch (e) {
        debugPrint('   Error al serializar: $e');
      }
      
      // Usar getLabMemberships para todos los roles
      final response = await _readMembershipUseCase.search(finalSearchInputs, validPageInfo);

      if (response is EdgeLabMembershipInfo) {
        membershipList = response.edges;
        pageInfo = response.pageInfo;
        
        // Para usuarios ROOT/ADMIN, extraer los usuarios de las memberships
        if (_isRootUser) {
          userList = response.edges.map((membership) => membership.member).whereType<User>().toList();
        } else {
          userList = null;
        }
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      
      // Si el error es "Laboratory membership not found", no es un error fatal,
      // simplemente no hay resultados para esa búsqueda
      if (e.toString().contains('Laboratory membership not found') || 
          e.toString().contains('075')) {
        debugPrint('ℹ️ No se encontraron resultados para la búsqueda');
        membershipList = [];
        userList = [];
        pageInfo = PageInfo(total: 0, page: 1, pages: 0, split: _pageInfo?.split ?? 10);
        error = false; // No es un error, simplemente no hay resultados
      } else {
        error = true;
        membershipList = [];
        userList = [];
        
        // Mostrar error al usuario solo si es un error real
      }
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
