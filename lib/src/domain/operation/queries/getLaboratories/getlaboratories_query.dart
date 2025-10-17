import '/src/domain/operation/fields_builders/main.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class GetLaboratoriesQuery implements Operation{
  final EdgeLaboratoryFieldsBuilder builder;
  final String _name = 'getLaboratories';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  GetLaboratoriesQuery({required this.builder, this.declarativeArgs, this.alias, this.opArgs, this.directives});
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
  EdgeLaboratory result(Map<String, dynamic> data) {
    String name;
    name = alias ?? _name;
    return EdgeLaboratory.fromJson(data[name]);
  }

}
