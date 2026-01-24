import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:labs/src/domain/entities/main.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/presentation/providers/laboratory_notifier.dart';
import '/src/domain/operation/queries/getLabMemberships/getlabmemberships_query.dart';
import '/src/domain/operation/fields_builders/edgelabmembershipinfo_fields_builder.dart';
import '/src/domain/extensions/edgelabmembershipinfo_fields_builder_extension.dart';
import '/src/domain/usecases/LabMembership/read_labmembership_usecase.dart';
import 'package:provider/provider.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<LabMembershipInfo>? _membershipList;
  PageInfo? _pageInfo;

  late GqlConn _gqlConn;
  late ReadLabMembershipUsecase _readUseCase;
  late LaboratoryNotifier _laboratoryNotifier;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetLabMembershipsQuery _operation = GetLabMembershipsQuery(
    builder: EdgeLabMembershipInfoFieldsBuilder().defaultValues(),
  );

  bool get loading => _loading;
  bool get error => _error;
  List<LabMembershipInfo>? get membershipList => _membershipList;
  PageInfo? get pageInfo => _pageInfo;

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
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    _readUseCase = ReadLabMembershipUsecase(operation: _operation, conn: _gqlConn);
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }
  
  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando membresías...');
    getMemberships();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
  }

  Future<void> _init() async {
    await getMemberships();
  }

  Future<void> getMemberships() async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.build();

      if (response is EdgeLabMembershipInfo) {
        membershipList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getMemberships: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      membershipList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar membresías: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;

    try {
      final response = await _readUseCase.search(searchInputs, _pageInfo);

      if (response is EdgeLabMembershipInfo) {
        membershipList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search memberships: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      membershipList = [];

      // Mostrar error al usuario
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al buscar membresías: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]); // Recargar con la nueva página
  }
}
