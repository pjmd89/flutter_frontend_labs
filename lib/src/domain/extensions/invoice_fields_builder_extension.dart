import '/src/domain/operation/fields_builders/main.dart';

extension InvoiceFieldsBuilderExtension on InvoiceFieldsBuilder {
  InvoiceFieldsBuilder defaultValues() {
    return this
      ..id()
      ..patient(
        builder: (patientBuilder) {
          patientBuilder
            ..id()
            ..patientType()
            ..patientData(
              // Inline fragment para Person
              personBuilder: (personBuilder) {
                personBuilder
                  ..firstName(alias: 'personFirstName')
                  ..lastName(alias: 'personLastName')
                  ..sex(alias: 'personSex')
                  ..dni()
                  ..phone()
                  ..email()
                  ..address()
                  ..birthDate();
              },
              // Inline fragment para Animal
              animalBuilder: (animalBuilder) {
                animalBuilder
                  ..firstName(alias: 'animalFirstName')
                  ..lastName(alias: 'animalLastName')
                  ..sex(alias: 'animalSex')
                  ..species()
                  ..birthDate();
              },
            );
        },
      )
      ..totalAmount()
      ..orderID()
      ..paymentStatus()
      ..kind()
      ..billTo(
        builder: (billToBuilder) {
          billToBuilder
            ..firstName()
            ..lastName()
            ..dni()
            ..address();
        },
      )
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
