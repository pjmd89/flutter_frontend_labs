import '/src/domain/operation/fields_builders/main.dart';

extension EvaluationPackageFieldsBuilderExtension on EvaluationPackageFieldsBuilder {
  EvaluationPackageFieldsBuilder defaultValues() {
    return this
      ..id()
      ..status()
      ..pdfFilepath()
      ..completedAt()
      ..referred()
      ..observations()
      ..isApproved()
      ..bioanalystReview(
        builder: (bioanalystReviewBuilder) {
          bioanalystReviewBuilder
            ..bioanalyst(
              builder: (userBuilder) {
                userBuilder
                  ..id()
                  ..firstName()
                  ..lastName()
                  ..email();
              },
            )
            ..reviewedAt();
        },
      )
      ..valuesByExam(
        builder: (examResultBuilder) {
          examResultBuilder
            ..exam(
              builder: (examBuilder) {
                examBuilder
                  ..id()
                  ..template(
                    builder: (templateBuilder) {
                      templateBuilder
                        ..name();
                    },
                  )
                  ..baseCost();
              },
            )
            ..cost()
            ..indicatorValues(
              builder: (indicatorValueBuilder) {
                indicatorValueBuilder
                  ..value()
                  ..indicator(
                    builder: (indicatorBuilder) {
                      indicatorBuilder
                        ..name()
                        ..valueType()
                        ..unit()
                        ..normalRange();
                    },
                  );
              },
            );
        },
      )
      ..created()
      ..updated();
  }
}
