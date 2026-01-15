import 'package:flutter/material.dart';
import 'package:agile_front/agile_front.dart';
import 'package:labs/src/domain/entities/main.dart';
import 'package:labs/src/domain/usecases/Invoice/cancel_invoice_payment_usecase.dart';
import 'package:labs/src/presentation/providers/gql_notifier.dart';
import 'package:labs/src/infraestructure/services/error_service.dart';

class ViewModel extends ChangeNotifier {
  late GqlConn _gqlConn;
  late ErrorService _errorService;
  final BuildContext _context;

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ViewModel({required BuildContext context}) : _context = context {
    _gqlConn = _context.read<GQLNotifier>().gqlConn;
    _errorService = _context.read<ErrorService>();
  }

  Future<bool> cancel({required String id}) async {
    loading = true;
    try {
      final useCase = CancelInvoicePaymentUsecase(conn: _gqlConn);
      final response = await useCase.execute(invoiceID: id);

      if (response is Invoice) {
        _errorService.showError(
          message: 'Pago cancelado exitosamente',
          type: ErrorType.success,
        );
        return true;
      }
      return false;
    } catch (e) {
      _errorService.showError(
        message: 'Error: ${e.toString()}',
      );
      return false;
    } finally {
      loading = false;
    }
  }
}
