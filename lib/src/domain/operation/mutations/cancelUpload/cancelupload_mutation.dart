import 'package:labs/src/domain/operation/fields_builders/upload_fields_builder.dart';
import '/src/domain/entities/main.dart';
import 'package:agile_front/infraestructure/operation.dart';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class CancelUploadMutation implements Operation{
  final UploadFieldsBuilder builder;
  final String _name = 'cancelUpload';
  Map<String,String>? declarativeArgs;
  final String? alias;
  Map<String, dynamic>? opArgs;
  List<Directive>? directives;

  @override
  get name => _name;
  CancelUploadMutation({required this.builder, this.declarativeArgs, this.alias, this.opArgs, this.directives});
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
      mutation $_name$variablesStr {
        $body
      }
    ''';
  }
  @override
  Upload result(Map<String, dynamic> data) {
    String name;
    name = alias ?? _name;
    return Upload.fromJson(data[name]);
  }

}
