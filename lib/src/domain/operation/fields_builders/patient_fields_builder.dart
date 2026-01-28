// GENERATED. NO EDITAR MANUALMENTE.
import 'dart:core';
import 'package:agile_front/infraestructure/graphql/helpers.dart';
import 'main.dart';
class PatientFieldsBuilder {
  final List<String> _fields = [];
  
  PatientFieldsBuilder id({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("_id", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  PatientFieldsBuilder patientType({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("patientType", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  // patientData con inline fragments para union type
  PatientFieldsBuilder patientData({
    String? alias,
    Map<String, dynamic>? args,
    List<Directive>? directives,
    void Function(PersonFieldsBuilder)? personBuilder,
    void Function(AnimalFieldsBuilder)? animalBuilder,
  }) {
    final fragments = <String>[];
    
    // Fragment para Person
    if (personBuilder != null) {
      final personChild = PersonFieldsBuilder();
      personBuilder(personChild);
      fragments.add('... on Person { ${personChild.build()} }');
    }
    
    // Fragment para Animal
    if (animalBuilder != null) {
      final animalChild = AnimalFieldsBuilder();
      animalBuilder(animalChild);
      fragments.add('... on Animal { ${animalChild.build()} }');
    }
    
    final selection = fragments.isNotEmpty ? fragments.join(' ') : '';
    final fieldStr = formatField("patientData", 
      alias: alias, 
      args: args, 
      directives: directives, 
      selection: selection
    );
    _fields.add(fieldStr);
    return this;
  }
  
  PatientFieldsBuilder metadata({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(KeyValuePairFieldsBuilder)? builder}) {
    final child = KeyValuePairFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("metadata", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  
  PatientFieldsBuilder laboratory({String? alias, Map<String, dynamic>? args, List<Directive>? directives, void Function(LaboratoryFieldsBuilder)? builder}) {
    final child = LaboratoryFieldsBuilder();
    if (builder != null) builder(child);
    final fieldStr = formatField("laboratory", alias: alias, args: args, directives: directives, selection: child.build());
    _fields.add(fieldStr);
    return this;
  }
  
  PatientFieldsBuilder created({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("created", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  PatientFieldsBuilder updated({String? alias, Map<String, dynamic>? args, List<Directive>? directives}) {
    final fieldStr = formatField("updated", alias: alias, args: args, directives: directives);
    _fields.add(fieldStr);
    return this;
  }
  
  String build() => _fields.join(" ");
}
