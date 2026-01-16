import '/src/domain/operation/fields_builders/main.dart';

extension EdgeExamFieldsBuilderExtension on EdgeExamFieldsBuilder {
  EdgeExamFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (examBuilder) {
          examBuilder
            ..id()
            ..template(
              builder: (templateBuilder) {
                templateBuilder
                  ..id()
                  ..name()
                  ..description();
              },
            )
            ..laboratory(
              builder: (laboratoryBuilder) {
                laboratoryBuilder
                  ..id()
                  ..address()
                  ..company(
                    builder: (companyBuilder) {
                      companyBuilder
                        ..id()
                        ..name();
                    },
                  );
              },
            )
            ..baseCost()
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
