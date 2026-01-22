import 'package:agile_front/agile_front.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/extensions/edgeinvoice_fields_builder_extension.dart';
import 'package:labs/src/domain/operation/queries/getInvoices/getinvoices_query.dart';
import 'package:labs/src/domain/usecases/Invoice/read_invoice_usecase.dart';
import '/src/presentation/providers/gql_notifier.dart';
import '/src/domain/operation/fields_builders/main.dart';

class ViewModel extends ChangeNotifier {
  bool _loading = false;
  bool _error = false;
  List<Invoice>? _invoiceList;
  final String laboratoryId;

  late GqlConn _gqlConn;
  late ReadInvoiceUsecase _readInvoiceUseCase;
  final BuildContext _context;

  // Query para obtener Invoices filtrados por laboratory._id
  final GetInvoicesQuery _invoiceOperation = GetInvoicesQuery(
    builder: EdgeInvoiceFieldsBuilder().defaultValues(),
  );

  ViewModel({required BuildContext context, required this.laboratoryId}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _readInvoiceUseCase = ReadInvoiceUsecase(operation: _invoiceOperation, conn: _gqlConn);
  }

  bool get loading => _loading;
  bool get error => _error;
  List<Invoice>? get invoiceList => _invoiceList;

  Future<void> loadInvoices() async {
    _loading = true;
    _error = false;
    notifyListeners();

    try {
      debugPrint('🔍 Obteniendo TODOS los invoices...');
      debugPrint('📋 laboratoryId para filtrar: $laboratoryId');
      
      final response = await _readInvoiceUseCase.build();
      
      if (response is EdgeInvoice) {
        final allInvoices = response.edges;
        debugPrint('📦 Total invoices en BD: ${allInvoices.length}');
        
        // Filtrar en el frontend por laboratory._id = laboratoryId
        _invoiceList = allInvoices.where((invoice) {
          final labMatches = invoice.laboratory?.id == laboratoryId;
          debugPrint('   Invoice: ${invoice.orderID} - Laboratory ID: ${invoice.laboratory?.id} - Match: $labMatches');
          return labMatches;
        }).toList();
        
        debugPrint('✅ Encontrados ${_invoiceList?.length ?? 0} invoices filtrados para laboratoryId: $laboratoryId');
        _loading = false;
        notifyListeners();
      }
    } catch (e, stackTrace) {
      debugPrint('💥 Error en loadInvoices: $e');
      debugPrint('📍 StackTrace: $stackTrace');
      _error = true;
      _loading = false;
      _invoiceList = [];
      notifyListeners();
      
      _context.read<GQLNotifier>().errorService.showError(
        message: 'Error al cargar facturación: ${e.toString()}',
      );
    }
  }
}
