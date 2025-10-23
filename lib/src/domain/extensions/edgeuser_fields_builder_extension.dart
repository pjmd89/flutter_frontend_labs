import '/src/domain/operation/fields_builders/main.dart';

extension EdgeUserFieldsBuilderExtension on EdgeUserFieldsBuilder {
  EdgeUserFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (userBuilder) {
          userBuilder
            ..id()
            ..firstName()
            ..lastName()
            ..role()
            ..email()
            ..cutOffDate()
            ..fee();
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
