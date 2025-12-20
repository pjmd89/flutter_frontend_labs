import '/src/domain/operation/fields_builders/main.dart';

extension LaboratoryFieldsBuilderExtension on LaboratoryFieldsBuilder {
  LaboratoryFieldsBuilder defaultValues() {
    return this
      ..id()
      ..address()
      ..contactPhoneNumbers()
      ..company(builder: (companyBuilder) {
        companyBuilder
          ..id()
          .name();
      });
  }
}
