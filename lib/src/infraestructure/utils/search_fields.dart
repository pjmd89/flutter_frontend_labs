import 'package:labs/src/domain/entities/main.dart';

class SearchFields{
  String field;
  KindEnum kind;
  OperatorEnum operator;
  SearchFields({
    required this.field,
    this.kind = KindEnum.string,
    this.operator = OperatorEnum.regex,
  });
}