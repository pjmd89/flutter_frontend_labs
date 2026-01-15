import '/src/domain/operation/fields_builders/main.dart';

extension InvoiceFieldsBuilderExtension on InvoiceFieldsBuilder {
  InvoiceFieldsBuilder defaultValues() {
    return this
      ..id()
      ..patient(
        builder: (patientBuilder) {
          patientBuilder
            ..id()
            ..firstName()
            ..lastName()
            ..sex()
            ..birthDate()
            ..species()
            ..dni()
            ..phone()
            ..email()
            ..address();
        },
      )
      ..totalAmount()
      ..laboratory(
        builder: (laboratoryBuilder) {
          laboratoryBuilder
            ..id()
            ..address();
        },
      )
      ..evaluationPackage(
        builder: (packageBuilder) {
          packageBuilder
            ..id();
        },
      )
      ..created()
      ..updated();
  }
}
