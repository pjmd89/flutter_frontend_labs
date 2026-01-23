// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'package:labs/src/domain/operation/fields_builders/memberaccess_fields_builder.dart';
import 'main.dart';
class LabMembershipInfoFieldsBuilder {
  final List<String> _fields = [];
  LabMembershipInfoFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder role({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("role", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder member({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(UserFieldsBuilder)? builder}) {
    final child = UserFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("member", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder access({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(MemberAccessFieldsBuilder)? builder}) {
    final child = MemberAccessFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("access", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  LabMembershipInfoFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  String build() => _fields.join(" ");
}
