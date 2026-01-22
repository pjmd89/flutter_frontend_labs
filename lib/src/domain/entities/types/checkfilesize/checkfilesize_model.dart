import 'package:json_annotation/json_annotation.dart';

part 'checkfilesize_model.g.dart';

/// Modelo para verificar el tamaño de un archivo antes de subirlo
/// Retorna información sobre el estado actual del archivo en el servidor
@JsonSerializable()
class CheckFileSize {
  final String name;
  final double size;
  final String type;
  final String folder;
  final double sizeUploaded;
  final String display;

  CheckFileSize({
    required this.name,
    required this.size,
    required this.type,
    required this.folder,
    required this.sizeUploaded,
    required this.display,
  });

  factory CheckFileSize.fromJson(Map<String, dynamic> json) =>
      _$CheckFileSizeFromJson(json);

  Map<String, dynamic> toJson() => _$CheckFileSizeToJson(this);
}
