// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
class UploadFieldsBuilder {
  final List<String> _fields = [];
  UploadFieldsBuilder name({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("name", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UploadFieldsBuilder size({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("size", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UploadFieldsBuilder type({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("type", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UploadFieldsBuilder folder({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("folder", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UploadFieldsBuilder sizeUploaded({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("sizeUploaded", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  UploadFieldsBuilder display({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("display", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
