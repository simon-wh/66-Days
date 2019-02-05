// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GlobalSettings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) {
  return GlobalSettings()
    ..dailyNotification = json['dailyNotification'] == null
        ? null
        : NotificationConfig.fromJson(
            json['dailyNotification'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GlobalSettingsToJson(GlobalSettings instance) =>
    <String, dynamic>{'dailyNotification': instance.dailyNotification};
