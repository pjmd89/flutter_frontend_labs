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
            ..address()
            ..laboratory(
              builder: (labBuilder) {
                labBuilder
                  ..id()
                  ..address();
              },
            );
        },
      )
      ..totalAmount()
      ..orderID()
      ..paymentStatus()
      ..kind()
      ..laboratory(
        builder: (laboratoryBuilder) {
          laboratoryBuilder
            ..id()
            ..address()
            ..contactPhoneNumbers()
            ..company(
              builder: (companyBuilder) {
                companyBuilder
                  ..id()
                  ..name()
                  ..logo()
                  ..taxID()
                  ..owner(builder: (userBuilder) {
                    userBuilder
                      ..id()
                      ..firstName()
                      ..lastName()
                      ..email();
                  });
              },
            );
        },
      )
      ..evaluationPackage(
        builder: (packageBuilder) {
          packageBuilder
            ..id()
            ..status()
            ..pdfFilepath()
            //..completedAt()
            ..referred()
            ..observations();
        },
      )
      ..created()
      ..updated();
  }
}
