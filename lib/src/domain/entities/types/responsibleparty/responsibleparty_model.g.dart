// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responsibleparty_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponsibleParty _$ResponsiblePartyFromJson(Map<String, dynamic> json) =>
    ResponsibleParty(
      firstName: json['firstName'] as String? ?? "",
      lastName: json['lastName'] as String? ?? "",
      dni: json['dni'] as String? ?? "",
      address: json['address'] as String? ?? "",
    );

Map<String, dynamic> _$ResponsiblePartyToJson(ResponsibleParty instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dni': instance.dni,
      'address': instance.address,
    };
