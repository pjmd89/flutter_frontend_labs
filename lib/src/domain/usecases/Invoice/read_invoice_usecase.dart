import 'dart:async';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';
import '/src/domain/operation/queries/getInvoices/getinvoices_query.dart';

class ReadInvoiceUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;
  ReadInvoiceUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
      _conn = conn;

  @override
  Future<dynamic> build() async {
    return await _conn.operation(operation: _operation, callback: callback);
  }

  Future<dynamic> search(List<SearchInput> search, PageInfo? pageInfo) async {
    (_operation as GetInvoicesQuery).declarativeArgs = {
      "search": "[SearchInput]",
    };

    _operation.directives = [
      Directive('search', {'input': GqlVar('search')}),
      if (pageInfo != null)
        Directive('paginate', {'page': pageInfo.page, 'split': pageInfo.split}),
    ];
    return _conn.operation(
      operation: _operation,
      variables: {'search': search.map((e) => e.toJson()).toList()},
    );
  }

  callback(Object ob) {
    //final thisObject = ob as EdgeInvoice;
  }
}
