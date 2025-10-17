import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgeinvoice_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeInvoice {
  final List<Invoice> edges;
  final PageInfo? pageInfo;
  EdgeInvoice({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeInvoice.fromJson(Map<String, dynamic> json) => _$EdgeInvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeInvoiceToJson(this);
}
