import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgeinvoice_fields_builder_extension.dart';
import 'package:labs/src/domain/extensions/invoice_fields_builder_extension.dart';
import 'package:labs/src/presentation/providers/laboratory_notifier.dart';
import 'package:labs/src/domain/operation/fields_builders/main.dart';
import 'package:labs/src/domain/operation/queries/getInvoices/getinvoices_query.dart';
import 'package:labs/src/domain/operation/mutations/markInvoiceAsPaid/markinvoiceaspaid_mutation.dart';
import 'package:labs/src/domain/operation/mutations/cancelInvoicePayment/cancelinvoicepayment_mutation.dart';
import 'package:labs/src/domain/usecases/Invoice/read_invoice_usecase.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';
import 'package:labs/src/infraestructure/services/error_service.dart';
import 'package:labs/l10n/app_localizations.dart';

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
  late LaboratoryNotifier _laboratoryNotifier;
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
    _laboratoryNotifier = _context.read<LaboratoryNotifier>();
    _readUseCase = ReadInvoiceUsecase(
      operation: _operation,
      conn: _gqlConn,
    );
    
    // Escuchar cambios en el laboratorio seleccionado
    _laboratoryNotifier.addListener(_onLaboratoryChanged);
    
    _init();
  }

  /// Se ejecuta cuando cambia el laboratorio seleccionado
  void _onLaboratoryChanged() {
    debugPrint('🔄 Laboratorio cambiado, recargando facturas...');
    getInvoices();
  }
  
  @override
  void dispose() {
    _laboratoryNotifier.removeListener(_onLaboratoryChanged);
    super.dispose();
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
  
  // Actualizar estado de pago de una factura
  Future<void> updatePaymentStatus(String invoiceId, PaymentStatus newStatus) async {
    loading = true;
    
    try {
      debugPrint('\n🔄 ========== UPDATE PAYMENT STATUS ==========');
      debugPrint('🔄 InvoiceID: $invoiceId');
      debugPrint('🔄 Nuevo estado: $newStatus');
      
      final l10n = AppLocalizations.of(_context)!;
      
      // Ejecutar la mutación correspondiente según el nuevo estado
      Invoice? updatedInvoice;
      
      if (newStatus == PaymentStatus.pAID) {
        // Marcar como pagado
        debugPrint('✅ Ejecutando markInvoiceAsPaid...');
        
        final mutation = MarkInvoiceAsPaidMutation(
          builder: InvoiceFieldsBuilder().defaultValues(),
          declarativeArgs: {"invoiceID": "ID!"},
          opArgs: {"invoiceID": GqlVar("invoiceID")},
        );
        
        final response = await _gqlConn.operation(
          operation: mutation,
          variables: {"invoiceID": invoiceId},
        );
        
        if (response is Invoice) {
          updatedInvoice = response;
          debugPrint('✅ Factura marcada como pagada exitosamente');
          _errorService.showError(
            message: 'Factura marcada como pagada',
            type: ErrorType.success,
          );
        }
        
      } else if (newStatus == PaymentStatus.cANCELED) {
        // Cancelar pago
        debugPrint('❌ Ejecutando cancelInvoicePayment...');
        
        final mutation = CancelInvoicePaymentMutation(
          builder: InvoiceFieldsBuilder().defaultValues(),
          declarativeArgs: {"invoiceID": "ID!"},
          opArgs: {"invoiceID": GqlVar("invoiceID")},
        );
        
        final response = await _gqlConn.operation(
          operation: mutation,
          variables: {"invoiceID": invoiceId},
        );
        
        if (response is Invoice) {
          updatedInvoice = response;
          debugPrint('✅ Pago de factura cancelado exitosamente');
          _errorService.showError(
            message: 'Pago cancelado exitosamente',
            type: ErrorType.success,
          );
        }
      }
      
      // Actualizar la factura en la lista local
      if (updatedInvoice != null && _invoiceList != null) {
        final index = _invoiceList!.indexWhere((inv) => inv.id == invoiceId);
        if (index != -1) {
          _invoiceList![index] = updatedInvoice;
          notifyListeners();
          debugPrint('✅ Lista local actualizada');
        }
      }
      
      debugPrint('========================================\n');
      
    } catch (e, stackTrace) {
      debugPrint('\n💥 ========== ERROR AL ACTUALIZAR PAGO ==========');
      debugPrint('💥 Error: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      debugPrint('========================================\n');
      
      _errorService.showError(
        message: 'Error al actualizar estado de pago: ${e.toString()}',
        type: ErrorType.error,
      );
    } finally {
      loading = false;
    }
  }
}
