import '/src/domain/operation/fields_builders/main.dart';

extension EdgeExamTemplateFieldsBuilderExtension
    on EdgeExamTemplateFieldsBuilder {
  EdgeExamTemplateFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (examTemplateBuilder) {
          examTemplateBuilder
            ..id()
            ..name()
            ..description()
            ..indicators(
              builder: (examIndicatorBuilder) {
                examIndicatorBuilder
                  ..name()
                  ..valueType()
                  ..unit()
                  ..normalRange();
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
