// To parse this JSON data, do
//
//     final getScheduleByRoomRequest = getScheduleByRoomRequestFromJson(jsonString);

import 'dart:convert';

GetScheduleByRoomRequest getScheduleByRoomRequestFromJson(String str) =>
    GetScheduleByRoomRequest.fromJson(json.decode(str));

String getScheduleByRoomRequestToJson(GetScheduleByRoomRequest data) =>
    json.encode(data.toJson());

class GetScheduleByRoomRequest {
  List<String>? schedules;
  Time? startTime;
  Time? endTime;
  int? availabilityViewInterval;

  GetScheduleByRoomRequest({
    this.schedules,
    this.startTime,
    this.endTime,
    this.availabilityViewInterval,
  });

  factory GetScheduleByRoomRequest.fromJson(Map<String, dynamic> json) =>
      GetScheduleByRoomRequest(
        schedules: json["schedules"] == null
            ? []
            : List<String>.from(json["schedules"]!.map((x) => x)),
        startTime:
            json["startTime"] == null ? null : Time.fromJson(json["startTime"]),
        endTime:
            json["endTime"] == null ? null : Time.fromJson(json["endTime"]),
        availabilityViewInterval: json["availabilityViewInterval"],
      );

  Map<String, dynamic> toJson() => {
        "schedules": schedules == null
            ? []
            : List<dynamic>.from(schedules!.map((x) => x)),
        "startTime": startTime?.toJson(),
        "endTime": endTime?.toJson(),
        "availabilityViewInterval": availabilityViewInterval,
      };
}

class Time {
  String? dateTime;
  String? timeZone;

  Time({
    this.dateTime,
    this.timeZone,
  });

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        dateTime: json["dateTime"],
        timeZone: json["timeZone"],
      );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime,
        "timeZone": timeZone,
      };
}
