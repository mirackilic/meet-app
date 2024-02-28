// To parse this JSON data, do
//
//     final getCalendarsResponse = getCalendarsResponseFromJson(jsonString);

import 'dart:convert';

GetCalendarsResponse getCalendarsResponseFromJson(String str) => GetCalendarsResponse.fromJson(json.decode(str));

String getCalendarsResponseToJson(GetCalendarsResponse data) => json.encode(data.toJson());

class GetCalendarsResponse {
    String? odataContext;
    List<Calendar>? value;

    GetCalendarsResponse({
        this.odataContext,
        this.value,
    });

    factory GetCalendarsResponse.fromJson(Map<String, dynamic> json) => GetCalendarsResponse(
        odataContext: json["@odata.context"],
        value: json["value"] == null ? [] : List<Calendar>.from(json["value"]!.map((x) => Calendar.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "@odata.context": odataContext,
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x.toJson())),
    };
}

class Calendar {
    String? id;
    String? name;
    String? color;
    String? hexColor;
    bool? isDefaultCalendar;
    String? changeKey;
    bool? canShare;
    bool? canViewPrivateItems;
    bool? canEdit;
    List<String>? allowedOnlineMeetingProviders;
    String? defaultOnlineMeetingProvider;
    bool? isTallyingResponses;
    bool? isRemovable;
    Owner? owner;

    Calendar({
        this.id,
        this.name,
        this.color,
        this.hexColor,
        this.isDefaultCalendar,
        this.changeKey,
        this.canShare,
        this.canViewPrivateItems,
        this.canEdit,
        this.allowedOnlineMeetingProviders,
        this.defaultOnlineMeetingProvider,
        this.isTallyingResponses,
        this.isRemovable,
        this.owner,
    });

    factory Calendar.fromJson(Map<String, dynamic> json) => Calendar(
        id: json["id"],
        name: json["name"],
        color: json["color"],
        hexColor: json["hexColor"],
        isDefaultCalendar: json["isDefaultCalendar"],
        changeKey: json["changeKey"],
        canShare: json["canShare"],
        canViewPrivateItems: json["canViewPrivateItems"],
        canEdit: json["canEdit"],
        allowedOnlineMeetingProviders: json["allowedOnlineMeetingProviders"] == null ? [] : List<String>.from(json["allowedOnlineMeetingProviders"]!.map((x) => x)),
        defaultOnlineMeetingProvider: json["defaultOnlineMeetingProvider"],
        isTallyingResponses: json["isTallyingResponses"],
        isRemovable: json["isRemovable"],
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "color": color,
        "hexColor": hexColor,
        "isDefaultCalendar": isDefaultCalendar,
        "changeKey": changeKey,
        "canShare": canShare,
        "canViewPrivateItems": canViewPrivateItems,
        "canEdit": canEdit,
        "allowedOnlineMeetingProviders": allowedOnlineMeetingProviders == null ? [] : List<dynamic>.from(allowedOnlineMeetingProviders!.map((x) => x)),
        "defaultOnlineMeetingProvider": defaultOnlineMeetingProvider,
        "isTallyingResponses": isTallyingResponses,
        "isRemovable": isRemovable,
        "owner": owner?.toJson(),
    };
}

class Owner {
    String? name;
    String? address;

    Owner({
        this.name,
        this.address,
    });

    factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        name: json["name"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
    };
}
