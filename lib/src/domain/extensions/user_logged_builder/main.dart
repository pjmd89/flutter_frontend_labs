import 'package:labs/src/domain/operation/fields_builders/fields_builders.dart';

extension LoggedUserDefaultBuilder on LoggedUserFieldsBuilder {
  LoggedUserFieldsBuilder defaultValues() {
    return this
      ..user(builder: (userBuilder) {
        userBuilder
          ..id()
          ..firstName()
          ..lastName()
          ..role()
          ..email();
      })
      ..currentLaboratory(builder: (labBuilder) {
        labBuilder
          ..id()
          ..address()
          ..company(builder: (companyBuilder) {
            companyBuilder
              ..id()
              ..name();
          
          });
      })
      ..labRole()
      ..userIsLabOwner();
  }
}