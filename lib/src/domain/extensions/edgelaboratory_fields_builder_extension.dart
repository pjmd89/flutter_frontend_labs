import '/src/domain/operation/fields_builders/main.dart';

extension EdgeLaboratoryFieldsBuilderExtension on EdgeLaboratoryFieldsBuilder {
  EdgeLaboratoryFieldsBuilder defaultValues() {
    return this
      ..edges(
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
                      ..email()
                      ..fee();
                  });
              },
            )
            ..created()
            ..updated();
        },
      )
      ..pageInfo(
        builder: (pageInfoBuilder) {
          pageInfoBuilder
            ..page()
            ..pages()
            ..split()
            ..shown()
            ..total()
            ..overall();
        },
      );
  }
}
