import 'package:labs/src/domain/operation/fields_builders/user_fields_builder.dart';

extension UserLoggedBuilder on UserFieldsBuilder {
  UserFieldsBuilder defaultValues() {
    this
      ..id()
      ..firstName()
      ..lastName()
      ..role()
      ..email();
    return this;
  }
}