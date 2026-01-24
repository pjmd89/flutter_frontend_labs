import '/src/domain/operation/fields_builders/main.dart';

extension UserFieldsBuilderExtension on UserFieldsBuilder {
  UserFieldsBuilder defaultValues() {
    return this
      ..id()
      ..firstName()
      ..lastName()
      ..role()    
      ..cutOffDate()
      ..fee();
  }
}
