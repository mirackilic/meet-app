// To parse this JSON data, do
//
//     final createMeetRequest = createMeetRequestFromJson(jsonString);

import 'dart:convert';

// CreateMeetRequest createMeetRequestFromJson(String str) =>
//     CreateMeetRequest.fromJson(json.decode(str));

String createMeetRequestToJson(CreateMeetRequest data) =>
    json.encode(data.toJson());

class CreateMeetRequest {
  String? subject;
  MeetTime? start;
  MeetTime? end;

  CreateMeetRequest({
    this.subject,
    this.start,
    this.end,
  });

  // factory CreateMeetRequest.fromJson(Map<String, dynamic> json) => CreateMeetRequest(
  //     subject: json["subject"],
  //     start: json["start"] == null ? null : MeetTime.fromJson(json["start"]),
  //     end: json["end"] == null ? null : MeetTime.fromJson(json["end"]),
  // );

  Map<String, dynamic> toJson() => {
        "subject": subject,
        "start": start?.toJson(),
        "end": end?.toJson(),
      };
}

class MeetTime {
  String? dateTime;
  String? timeZone;

  MeetTime({
    this.dateTime,
    this.timeZone,
  });

  // factory MeetTime.fromJson(Map<String, dynamic> json) => MeetTime(
  //     dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
  //     timeZone: json["timeZone"],
  // );

  Map<String, dynamic> toJson() => {
        "dateTime": dateTime,
        "timeZone": timeZone,
      };
}
