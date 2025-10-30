import '/src/domain/operation/fields_builders/main.dart';

extension ExamFieldsBuilderExtension on ExamFieldsBuilder {
  ExamFieldsBuilder defaultValues() {
    return this
      ..id()
      ..template(
        builder: (templateBuilder) {
          templateBuilder
            ..id()
            ..name()
            ..description();
        },
      )
      ..baseCost()
      ..created()
      ..updated();
  }
}
