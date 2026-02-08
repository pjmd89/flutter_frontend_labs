import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/extensions/person_fields_builder_extension.dart';

extension EdgePersonFieldsBuilderExtension on EdgePersonFieldsBuilder {
  EdgePersonFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (personBuilder) {
          personBuilder.defaultValues();
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
