import '/src/domain/operation/fields_builders/main.dart';

extension CompanyFieldsBuilderExtension on CompanyFieldsBuilder {
  CompanyFieldsBuilder defaultValues() {
    return this
      ..id()
      ..name()
      ..logo()
      ..taxID()
      ..created()
      ..updated();
  }
}
