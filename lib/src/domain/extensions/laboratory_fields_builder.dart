import '/src/domain/operation/fields_builders/main.dart';

extension EdgeLaboratoryFieldsBuilderExtension on EdgeLaboratoryFieldsBuilder {
  EdgeLaboratoryFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (laboratoryBuilder) {
          laboratoryBuilder
            ..id()
            ..employees(builder: (edgeUserBuilder) {
              edgeUserBuilder.edges(builder: (userBuilder) {
                userBuilder
                  ..id()
                  ..firstName()
                  ..lastName()
                  ..email();
              });
            })
            ..address()
            ..company(builder: (companyBuilder) {
              companyBuilder
                ..id()
                ..name();
            })
            ..contactPhoneNumbers();           
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
