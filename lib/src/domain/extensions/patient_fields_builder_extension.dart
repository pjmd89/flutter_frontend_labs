import '/src/domain/operation/fields_builders/main.dart';

extension PatientFieldsBuilderExtension on PatientFieldsBuilder {
  PatientFieldsBuilder defaultValues() {
    return this
      ..id()
      ..firstName()
      ..lastName()
      ..sex()
      ..birthDate()
      ..species()
      ..dni()
      ..phone()
      ..email()
      ..address()
      ..created()
      ..updated();
  }
}
