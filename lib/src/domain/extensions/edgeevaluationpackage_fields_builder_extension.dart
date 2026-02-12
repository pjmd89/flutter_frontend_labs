import '/src/domain/operation/fields_builders/main.dart';

extension EdgeEvaluationPackageFieldsBuilderExtension on EdgeEvaluationPackageFieldsBuilder {
  EdgeEvaluationPackageFieldsBuilder defaultValues() {
    return this
      ..edges(
        builder: (evaluationPackageBuilder) {
          evaluationPackageBuilder
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
                              ..id()
                              ..name();
                          },
                        );
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
                              ..unit()
                              ..valueType();
                          },
                        );
                    },
                  );
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
