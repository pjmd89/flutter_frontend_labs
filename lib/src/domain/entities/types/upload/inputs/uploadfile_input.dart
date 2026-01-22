import 'package:json_annotation/json_annotation.dart';

part 'uploadfile_input.g.dart';

/// Input para subir archivos
/// Representa un fragmento del archivo en base64
@JsonSerializable(includeIfNull: false)
class UploadFileInput {
  final String name;
  final int size;
  final String type;
  final String folder;
  final String file; // Fragmento en base64
  final bool? isThumb;

  UploadFileInput({
    required this.name,
    required this.size,
    required this.type,
    required this.folder,
    required this.file,
    this.isThumb,
  });

  factory UploadFileInput.fromJson(Map<String, dynamic> json) =>
      _$UploadFileInputFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFileInputToJson(this);
}
