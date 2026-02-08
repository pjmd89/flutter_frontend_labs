import "/src/domain/entities/main.dart";

class EdgePerson {
  final List<Person> edges;
  final PageInfo? pageInfo;

  EdgePerson({
    this.edges = const [],
    this.pageInfo,
  });

  factory EdgePerson.fromJson(Map<String, dynamic> json) {
    final edgesJson = json['edges'] as List<dynamic>? ?? const [];
    return EdgePerson(
      edges: edgesJson.map((e) => Person.fromJson(e as Map<String, dynamic>)).toList(),
      pageInfo: json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'edges': edges.map((e) => e.toJson()).toList(),
      if (pageInfo != null) 'pageInfo': pageInfo!.toJson(),
    };
  }
}
