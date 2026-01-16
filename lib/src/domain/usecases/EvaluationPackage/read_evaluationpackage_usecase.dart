import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getEvaluationPackages/getexamresults_query.dart';
import '/src/domain/extensions/edgeevaluationpackage_fields_builder_extension.dart';

class ReadEvaluationPackageUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  ReadEvaluationPackageUsecase({
    required af.Operation operation,
    required af.Service conn,
  })  : _operation = operation,
        _conn = conn;

  @override
  Future<dynamic> build() async {
    var data = _conn.operation(operation: _operation, callback: callback);
    return data;
  }

  Future<dynamic> search(List<SearchInput> search, PageInfo? pageInfo) async {
    // Solo agregar directiva de search si hay criterios
    if (search.isNotEmpty) {
      (_operation as GetExamResultsQuery).declarativeArgs = {
        "search": "[SearchInput]"
      };
    } else {
      (_operation as GetExamResultsQuery).declarativeArgs = null;
    }

    _operation.directives = [
      if (search.isNotEmpty)
        Directive('search', {'input': GqlVar('search')}),
      if (pageInfo != null)
        Directive('paginate', {
          'page': pageInfo.page,
          'split': pageInfo.split,
        }),
    ];
    
    return _conn.operation(
      operation: _operation,
      variables: search.isNotEmpty 
          ? {'search': search.map((e) => e.toJson()).toList()}
          : {},
    );
  }

  Future<dynamic> readWithoutPaginate() async {
    EdgeEvaluationPackageFieldsBuilder builder = 
        EdgeEvaluationPackageFieldsBuilder().defaultValues();
    final response = await _conn.operation(
      operation: GetExamResultsQuery(builder: builder),
      variables: {},
    );
    return response;
  }

  callback(Object ob) {
    // final thisObject = ob as EdgeEvaluationPackage;
  }
}
