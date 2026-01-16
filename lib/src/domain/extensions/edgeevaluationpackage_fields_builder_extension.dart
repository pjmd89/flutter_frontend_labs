import '/src/domain/operation/fields_builders/main.dart';

extension EdgeEvaluationPackageFieldsBuilderExtension on EdgeEvaluationPackageFieldsBuilder {
  EdgeEvaluationPackageFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (evaluationPackageBuilder) {
          evaluationPackageBuilder
            ..id()
            ..status()
            ..referred()
            ..observations()
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
