// To parse this JSON data, do
//
//     final createCalendarRequest = createCalendarRequestFromJson(jsonString);

import 'dart:convert';

CreateCalendarRequest createCalendarRequestFromJson(String str) =>
    CreateCalendarRequest.fromJson(json.decode(str));

String createCalendarRequestToJson(CreateCalendarRequest data) =>
    json.encode(data.toJson());

class CreateCalendarRequest {
  String? name;

  CreateCalendarRequest({
    this.name,
  });

  factory CreateCalendarRequest.fromJson(Map<String, dynamic> json) =>
      CreateCalendarRequest(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
