import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/inputs/valueinput_input.dart';
import '/src/domain/entities/enums/operatorenum_enum.dart';
import '/src/domain/entities/enums/kindenum_enum.dart';
import '/src/domain/operation/queries/getEvaluationPackage/getevaluationpackage_query.dart';

class ReadOneEvaluationPackageUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  ReadOneEvaluationPackageUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    return _conn.operation(operation: _operation, callback: callback);
  }
  
  Future<dynamic> readOne(String id) async {
    (_operation as GetEvaluationPackageQuery).declarativeArgs = {
      "search": "[SearchInput]"
    };
    
    _operation.directives = [
      Directive('search', {'input': GqlVar('search')}),
    ];
    
    final valueInput = ValueInput(
      value: id,
      operator: OperatorEnum.eq,
      kind: KindEnum.iD,
    );
    final searchInput = SearchInput(
      field: '_id',
      value: [valueInput],
    );
    
    return _conn.operation(
      operation: _operation,
      variables: {
        'search': [searchInput.toJson()]
      },
    );
  }

  callback(Object ob) {
    // final thisObject = ob as EvaluationPackage;
  }
}
