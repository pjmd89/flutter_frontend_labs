import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/extensions/invoice_fields_builder_extension.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/mutations/cancelInvoicePayment/cancel_invoice_payment_mutation.dart';

class CancelInvoicePaymentUsecase implements af.UseCase {
  final af.Service _conn;

  CancelInvoicePaymentUsecase({
    required af.Service conn,
  }) : _conn = conn;

  @override
  Future<dynamic> build() async {
    throw UnimplementedError('Use execute method instead');
  }

  callback(Object ob) {
    // final thisObject = ob as Invoice;
  }

  Future<dynamic> execute({required String invoiceID}) async {
    InvoiceFieldsBuilder fieldsBuilder = InvoiceFieldsBuilder().defaultValues();

    CancelInvoicePaymentMutation mutation = CancelInvoicePaymentMutation(
      declarativeArgs: {"invoiceID": 'ID!'},
      builder: fieldsBuilder,
      opArgs: {"invoiceID": GqlVar("invoiceID")},
    );

    var response = await _conn.operation(
      operation: mutation,
      variables: {'invoiceID': invoiceID},
    );

    return response;
  }
}
