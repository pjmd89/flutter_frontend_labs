import '/src/domain/operation/fields_builders/main.dart';

extension PersonFieldsBuilderExtension on PersonFieldsBuilder {
  PersonFieldsBuilder defaultValues() {
    return this
      ..id()
      ..firstName()
      ..lastName()
      ..dni()
      ..phone()
      ..email()
      ..address()
      ..birthDate()
      ..sex()
      ..laboratory(builder: (lab) {
        lab.id();
      })
      ..created()
      ..updated();
  }
}
