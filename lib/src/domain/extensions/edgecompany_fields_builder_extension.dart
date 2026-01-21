import '/src/domain/operation/fields_builders/main.dart';

extension EdgeCompanyFieldsBuilderExtension on EdgeCompanyFieldsBuilder {
  EdgeCompanyFieldsBuilder defaultValues() {
    return this
      ..edges(
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
            })
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
