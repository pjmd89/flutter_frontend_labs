import 'package:json_annotation/json_annotation.dart';

part 'checkupload_input.g.dart';

/// Input para verificar el tamaño de un archivo antes de subirlo
/// Permite al servidor indicar cuánto del archivo ya fue subido
@JsonSerializable(includeIfNull: false)
class CheckUploadInput {
  final String name;
  final double size;
  final String type;
  final String folder;

  CheckUploadInput({
    required this.name,
    required this.size,
    required this.type,
    required this.folder,
  });

  factory CheckUploadInput.fromJson(Map<String, dynamic> json) =>
      _$CheckUploadInputFromJson(json);

  Map<String, dynamic> toJson() => _$CheckUploadInputToJson(this);
}
