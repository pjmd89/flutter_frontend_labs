import '/src/domain/operation/fields_builders/main.dart';

extension EdgeLabMembershipInfoFieldsBuilderExtension on EdgeLabMembershipInfoFieldsBuilder {
  EdgeLabMembershipInfoFieldsBuilder defaultValues() {
    return this
      ..edges(builder: (membershipBuilder) {
        membershipBuilder
          ..id()
          ..role()
          ..member(builder: (userBuilder) {
            userBuilder
              ..id()
              ..firstName()
              ..lastName()
              ..email();
          })
          ..laboratory(builder: (labBuilder) {
            labBuilder
              ..id()
              ..address();
          })
          ..created()
          ..updated();
      })
      ..pageInfo(builder: (pageInfoBuilder) {
        pageInfoBuilder
          ..page()
          ..pages()
          ..split()
          ..shown()
          ..total()
          ..overall();
      });
  }
}
