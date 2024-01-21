// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutStep _$WorkoutStepFromJson(Map<String, dynamic> json) => WorkoutStep(
      name: json['name'] as String,
      duration: json['duration'] as int? ?? 0,
      restDuration: json['restDuration'] as int? ?? 0,
      order: json['order'] as int? ?? 0,
      type: $enumDecodeNullable(_$StepTypeEnumMap, json['type']) ??
          StepType.single,
      occurence: json['occurence'] as int? ?? 0,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => WorkoutStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WorkoutStepToJson(WorkoutStep instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration': instance.duration,
      'restDuration': instance.restDuration,
      'order': instance.order,
      'type': _$StepTypeEnumMap[instance.type]!,
      'children': instance.children,
      'occurence': instance.occurence,
    };

const _$StepTypeEnumMap = {
  StepType.repeat: 'repeat',
  StepType.single: 'single',
};
