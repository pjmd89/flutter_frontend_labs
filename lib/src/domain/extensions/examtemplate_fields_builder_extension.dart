import '/src/domain/operation/fields_builders/main.dart';

extension ExamTemplateFieldsBuilderExtension on ExamTemplateFieldsBuilder {
  ExamTemplateFieldsBuilder defaultValues() {
    return this
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
  }
}
