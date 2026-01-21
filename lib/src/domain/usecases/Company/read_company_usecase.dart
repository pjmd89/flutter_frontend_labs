import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:agile_front/agile_front.dart' as af;
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import '/src/domain/entities/inputs/searchinput_input.dart';
import '/src/domain/entities/types/pageinfo/pageinfo_model.dart';
import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/operation/queries/getCompanies/getcompanies_query.dart';
import '/src/domain/extensions/edgecompany_fields_builder_extension.dart';

class ReadCompanyUsecase implements af.UseCase {
  final af.Operation _operation;
  final af.Service _conn;

  ReadCompanyUsecase({
    required af.Operation operation,
    required af.Service conn,
  }) : _operation = operation,
       _conn = conn;

  @override
  Future<dynamic> build() async {
    debugPrint('🔧 Query GraphQL que se enviará:');
    debugPrint(_operation.build());
    debugPrint('---');
    final result = await _conn.operation(
      operation: _operation,
      callback: callback,
    );
    debugPrint('📥 Resultado de la operación: $result');
    return result;
  }

  Future<dynamic> search(List<SearchInput> search, PageInfo? pageInfo) async {
    (_operation as GetCompaniesQuery).declarativeArgs = {
      "search": "[SearchInput]",
    };

    _operation.directives = [
      Directive('search', {'input': GqlVar('search')}),
      if (pageInfo != null)
        Directive('paginate', {'page': pageInfo.page, 'split': pageInfo.split}),
    ];
    
    debugPrint('🔧 Query GraphQL con filtro:');
    debugPrint(_operation.build());
    debugPrint('📤 Variables: ${{'search': search.map((e) => e.toJson()).toList()}}');
    
    final result = await _conn.operation(
      operation: _operation,
      variables: {'search': search.map((e) => e.toJson()).toList()},
    );
    
    debugPrint('📥 Resultado de search: $result');
    return result;
  }

  Future<dynamic> readWithoutPaginate() async {
    EdgeCompanyFieldsBuilder builder =
        EdgeCompanyFieldsBuilder().defaultValues();
    final response = await _conn.operation(
      operation: GetCompaniesQuery(builder: builder),
      variables: {},
    );
    return response;
  }

  callback(Object ob) {
    // final thisObject = ob as EdgeCompany;
  }
}
