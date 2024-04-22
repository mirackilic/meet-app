// To parse this JSON data, do
//
//     final getMettingRoomsResponse = getMettingRoomsResponseFromJson(jsonString);

import 'dart:convert';

GetMettingRoomsResponse getMettingRoomsResponseFromJson(String str) =>
    GetMettingRoomsResponse.fromJson(json.decode(str));

String getMettingRoomsResponseToJson(GetMettingRoomsResponse data) =>
    json.encode(data.toJson());

class GetMettingRoomsResponse {
  bool? hasError;
  List<dynamic>? errors;
  List<MeetingRooms>? data;
  int? total;

  GetMettingRoomsResponse({
    this.hasError,
    this.errors,
    this.data,
    this.total,
  });

  factory GetMettingRoomsResponse.fromJson(Map<String, dynamic> json) =>
      GetMettingRoomsResponse(
        hasError: json["hasError"],
        errors: json["errors"] == null
            ? []
            : List<dynamic>.from(json["errors"]!.map((x) => x)),
        data: json["data"] == null
            ? []
            : List<MeetingRooms>.from(json["data"]!.map((x) => MeetingRooms.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "hasError": hasError,
        "errors":
            errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
      };
}

class MeetingRooms {
  String? id;
  String? mail;
  String? name;
  String? storeCode;
  String? graphId;

  MeetingRooms({
    this.id,
    this.mail,
    this.name,
    this.storeCode,
    this.graphId,
  });

  factory MeetingRooms.fromJson(Map<String, dynamic> json) => MeetingRooms(
        id: json["id"],
        mail: json["mail"],
        name: json["name"],
        storeCode: json["storeCode"],
        graphId: json["graphId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mail": mail,
        "name": name,
        "storeCode": storeCode,
        "graphId": graphId,
      };
}
