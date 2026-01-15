import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgeinvoice_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getInvoices/getinvoices_query.dart';
import 'package:labs/src/domain/usecases/Invoice/read_invoice_usecase.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';
import 'package:labs/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  // Estados privados
  bool _loading = false;
  bool _error = false;
  List<Invoice>? _invoiceList;
  PageInfo? _pageInfo;

  // Dependencias
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  late ReadInvoiceUsecase _readUseCase;
  final BuildContext _context;

  // Query con FieldsBuilder configurado
  final GetInvoicesQuery _operation = GetInvoicesQuery(
    builder: EdgeInvoiceFieldsBuilder().defaultValues(),
  );

  // Getters públicos
  bool get loading => _loading;
  bool get error => _error;
  List<Invoice>? get invoiceList => _invoiceList;
  PageInfo? get pageInfo => _pageInfo;

  // Setters con notificación
  set loading(bool newLoading) {
    _loading = newLoading;
    notifyListeners();
  }

  set error(bool value) {
    _error = value;
    notifyListeners();
  }

  set invoiceList(List<Invoice>? value) {
    _invoiceList = value;
    notifyListeners();
  }

  set pageInfo(PageInfo? value) {
    _pageInfo = value;
    notifyListeners();
  }

  // Constructor - Inicializa dependencias
  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
    _readUseCase = ReadInvoiceUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    _init();
  }

  // Inicialización - Carga datos al crear el ViewModel
  Future<void> _init() async {
    await getInvoices();
  }

  // Obtener todas las facturas (sin filtros)
  Future<void> getInvoices() async {
    loading = true;
    error = false;
    try {
      final response = await _readUseCase.build();
      if (response is EdgeInvoice) {
        invoiceList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en getInvoices: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      invoiceList = [];
      _errorService.showError(
        message: 'Error al cargar facturas: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Buscar facturas con filtros
  Future<void> search(List<SearchInput> searchInputs) async {
    loading = true;
    error = false;
    try {
      final response = await _readUseCase.search(searchInputs, pageInfo);
      if (response is EdgeInvoice) {
        invoiceList = response.edges;
        pageInfo = response.pageInfo;
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en search: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      error = true;
      invoiceList = [];
      _errorService.showError(
        message: 'Error al buscar facturas: ${e.toString()}',
      );
    } finally {
      loading = false;
    }
  }

  // Cambiar de página
  Future<void> updatePageInfo(PageInfo newPageInfo) async {
    _pageInfo = newPageInfo;
    await search([]);
  }
}
