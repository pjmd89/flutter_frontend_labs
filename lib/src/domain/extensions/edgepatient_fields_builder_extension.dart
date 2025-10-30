import '/src/domain/operation/fields_builders/main.dart';

extension EdgePatientFieldsBuilderExtension on EdgePatientFieldsBuilder {
  EdgePatientFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (patientBuilder) {
          patientBuilder
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
