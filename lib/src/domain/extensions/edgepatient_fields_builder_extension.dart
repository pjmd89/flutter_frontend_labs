import '/src/domain/operation/fields_builders/main.dart';

extension EdgePatientFieldsBuilderExtension on EdgePatientFieldsBuilder {
  EdgePatientFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (patientBuilder) {
          patientBuilder
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
                  ..birthDate();
              },
            )
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
