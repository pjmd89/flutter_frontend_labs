import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgelaboratory_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/edgecompany_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/queries/getLaboratories/getlaboratories_query.dart';
import 'package:labs/src/domain/operation/queries/getCompanies/getcompanies_query.dart';
import 'package:labs/src/domain/usecases/Laboratory/read_laboratory_usecase.dart';
import 'package:labs/src/domain/usecases/Company/read_company_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Laboratory>? _laboratoryList;
  final String userId;

  late GqlConn _gqlConn;
  late ReadLaboratoryUsecase _readLaboratoryUseCase;
  late ReadCompanyUsecase _readCompanyUseCase;
  final BuildContext _context;

  // Query para obtener Laboratories filtrados por company.owner._id
  final GetLaboratoriesQuery _laboratoryOperation = GetLaboratoriesQuery(
    builder: EdgeLaboratoryFieldsBuilder().defaultValues(),
  );
  
  // Query para obtener Companies del usuario
  final GetCompaniesQuery _companyOperation = GetCompaniesQuery(
    builder: EdgeCompanyFieldsBuilder().defaultValues(),
  );

  ViewModel({required BuildContext context, required this.userId}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readLaboratoryUseCase = ReadLaboratoryUsecase(operation: _laboratoryOperation, conn: _gqlConn);
    _readCompanyUseCase = ReadCompanyUsecase(operation: _companyOperation, conn: _gqlConn);
  }

  bool get loading => _loading;
  bool get error => _error;
  List<Laboratory>? get laboratoryList => _laboratoryList;

  Future<void> loadLaboratories() async {
    _loading = true;
    _error = false;
    notifyListeners();

    try {
      debugPrint('🔍 Obteniendo TODOS los laboratories...');
      debugPrint('📋 userId para filtrar: $userId');
      
      final response = await _readLaboratoryUseCase.build();
      
      if (response is EdgeLaboratory) {
        final allLaboratories = response.edges;
        debugPrint('📦 Total laboratories en BD: ${allLaboratories.length}');
        
        // Filtrar en el frontend por company.owner.id = userId
        _laboratoryList = allLaboratories.where((lab) {
          final ownerMatches = lab.company?.owner?.id == userId;
          debugPrint('   Lab: ${lab.company?.name ?? 'Sin nombre'} - Owner: ${lab.company?.owner?.id} - Match: $ownerMatches');
          return ownerMatches;
        }).toList();
        
        debugPrint('✅ Encontrados ${_laboratoryList?.length ?? 0} laboratories filtrados para userId: $userId');
        _loading = false;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadLaboratories: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _error = true;
      _loading = false;
      _laboratoryList = [];
      notifyListeners();
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar laboratorios: ${e.toString()}',
      );
    }
  }
}
