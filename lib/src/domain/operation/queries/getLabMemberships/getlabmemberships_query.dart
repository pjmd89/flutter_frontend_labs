import 'package:labs/src/domain/operation/fields_builders/edgelabmembershipinfo_fields_builder.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class GetLabMembershipsQuery implements Operation{
  final EdgeLabMembershipInfoFieldsBuilder builder;
  final String _name = 'getLabMemberships';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  GetLabMembershipsQuery({required this.builder, this.declarativeArgs, this.alias, this.opArgs, this.directives});
  @override
  String build({String? alias, Map<String, String>? declarativeArgs, Map<String, dynamic>? args, List<Directive>? directives}) {
    
    final fields = builder.build();
    // Construir declaración de variables GraphQL
    final variableDecl = declarativeArgs ?? this.declarativeArgs ?? {};
    final variablesStr = variableDecl.isNotEmpty ? '(${variableDecl.entries.map((e) => '\$${e.key}:${e.value}').join(',')})' : ''; 
    
    final body = formatField(
      _name,
      alias: alias ?? this.alias,
      args: args ?? opArgs,
      directives: directives ?? this.directives,
      selection: fields,
    );
    return '''
      query $_name$variablesStr {
        $body
      }
    ''';
  }
  @override
  EdgeLabMembershipInfo result(Map<String, dynamic> data) {
    String name;
    name = alias ?? _name;
    return EdgeLabMembershipInfo.fromJson(data[name]);
  }

}
