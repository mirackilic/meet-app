// To parse this JSON data, do
//
//     final getScheduleByRoomResponse = getScheduleByRoomResponseFromJson(jsonString);

import 'dart:convert';

GetScheduleByRoomResponse getScheduleByRoomResponseFromJson(String str) =>
    GetScheduleByRoomResponse.fromJson(json.decode(str));

String getScheduleByRoomResponseToJson(GetScheduleByRoomResponse data) =>
    json.encode(data.toJson());

class GetScheduleByRoomResponse {
  String? odataContext;
  List<Meetings>? value;

  GetScheduleByRoomResponse({
    this.odataContext,
    this.value,
  });

  factory GetScheduleByRoomResponse.fromJson(Map<String, dynamic> json) =>
      GetScheduleByRoomResponse(
        odataContext: json["@odata.context"],
        value: json["value"] == null
            ? []
            : List<Meetings>.from(
                json["value"]!.map((x) => Meetings.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "@odata.context": odataContext,
        "value": value == null
            ? []
            : List<dynamic>.from(value!.map((x) => x.toJson())),
      };
}

class Meetings {
  String? scheduleId;
  String? availabilityView;
  List<ScheduleItem>? scheduleItems;

  Meetings({
    this.scheduleId,
    this.availabilityView,
    this.scheduleItems,
  });

  factory Meetings.fromJson(Map<String, dynamic> json) => Meetings(
        scheduleId: json["scheduleId"],
        availabilityView: json["availabilityView"],
        scheduleItems: json["scheduleItems"] == null
            ? []
            : List<ScheduleItem>.from(
                json["scheduleItems"]!.map((x) => ScheduleItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "scheduleId": scheduleId,
        "availabilityView": availabilityView,
        "scheduleItems": scheduleItems == null
            ? []
            : List<dynamic>.from(scheduleItems!.map((x) => x.toJson())),
      };
}

class ScheduleItem {
  bool? isPrivate;
  String? status;
  String? subject;
  String? location;
  bool? isMeeting;
  bool? isRecurring;
  bool? isException;
  bool? isReminderSet;
  End? start;
  End? end;

  ScheduleItem({
    this.isPrivate,
    this.status,
    this.subject,
    this.location,
    this.isMeeting,
    this.isRecurring,
    this.isException,
    this.isReminderSet,
    this.start,
    this.end,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
        isPrivate: json["isPrivate"],
        status: json["status"],
        subject: json["subject"],
        location: json["location"],
        isMeeting: json["isMeeting"],
        isRecurring: json["isRecurring"],
        isException: json["isException"],
        isReminderSet: json["isReminderSet"],
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "isPrivate": isPrivate,
        "status": status,
        "subject": subject,
        "location": location,
        "isMeeting": isMeeting,
        "isRecurring": isRecurring,
        "isException": isException,
        "isReminderSet": isReminderSet,
        "start": start?.toJson(),
        "end": end?.toJson(),
      };
}

class End {
  DateTime? dateTime;
  String? timeZone;

  End({
    this.dateTime,
    this.timeZone,
  });

  factory End.fromJson(Map<String, dynamic> json) => End(
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        timeZone: json["timeZone"],
      );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime?.toIso8601String(),
        "timeZone": timeZone,
      };
}
