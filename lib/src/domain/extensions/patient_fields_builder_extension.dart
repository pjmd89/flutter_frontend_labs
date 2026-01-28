import '/src/domain/operation/fields_builders/main.dart';

extension PatientFieldsBuilderExtension on PatientFieldsBuilder {
  PatientFieldsBuilder defaultValues() {
    return this
      ..id()
      ..patientType()
      ..patientData(
        // Inline fragment para Person
        personBuilder: (personBuilder) {
          personBuilder
            ..firstName(alias: 'personFirstName')
            ..lastName(alias: 'personLastName')
            ..sex(alias: 'personSex')
            ..dni()
            ..phone()
            ..email()
            ..address()
            ..birthDate();
        },
        // Inline fragment para Animal
        animalBuilder: (animalBuilder) {
          animalBuilder
            ..firstName(alias: 'animalFirstName')
            ..lastName(alias: 'animalLastName')
            ..sex(alias: 'animalSex')
            ..species()
            ..birthDate()
            ..owner(builder: (ownerBuilder) {
              ownerBuilder
                ..firstName()
                ..lastName()
                ..phone()
                ..email();
            });
        },
      )
      ..created()
      ..updated();
  }
}
