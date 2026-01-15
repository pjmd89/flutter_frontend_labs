import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/extensions/invoice_fields_builder_extension.dart';

extension EdgeInvoiceFieldsBuilderExtension on EdgeInvoiceFieldsBuilder {
  EdgeInvoiceFieldsBuilder defaultValues() {
    return this
      ..pageInfo(
        builder: (pageInfoBuilder) {
          pageInfoBuilder
            ..page()
            ..pages()
            ..shown()
            ..total()
            ..overall();
        },
      )
      ..edges(
        builder: (invoiceBuilder) {
          invoiceBuilder.defaultValues();
        },
      );
  }
}
