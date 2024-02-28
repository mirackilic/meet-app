// To parse this JSON data, do
//
//     final myEventsResponse = myEventsResponseFromJson(jsonString);

import 'dart:convert';

MyEventsResponse myEventsResponseFromJson(String str) => MyEventsResponse.fromJson(json.decode(str));

String myEventsResponseToJson(MyEventsResponse data) => json.encode(data.toJson());

class MyEventsResponse {
    String? odataContext;
    List<Value>? value;

    MyEventsResponse({
        this.odataContext,
        this.value,
    });

    factory MyEventsResponse.fromJson(Map<String, dynamic> json) => MyEventsResponse(
        odataContext: json["@odata.context"],
        value: json["value"] == null ? [] : List<Value>.from(json["value"]!.map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "@odata.context": odataContext,
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x.toJson())),
    };
}

class Value {
    String? odataEtag;
    String? id;
    DateTime? createdDateTime;
    DateTime? lastModifiedDateTime;
    String? changeKey;
    List<dynamic>? categories;
    dynamic transactionId;
    String? originalStartTimeZone;
    String? originalEndTimeZone;
    String? iCalUId;
    int? reminderMinutesBeforeStart;
    bool? isReminderOn;
    bool? hasAttachments;
    String? subject;
    String? bodyPreview;
    String? importance;
    String? sensitivity;
    bool? isAllDay;
    bool? isCancelled;
    bool? isOrganizer;
    bool? responseRequested;
    String? seriesMasterId;
    String? showAs;
    String? type;
    String? webLink;
    dynamic onlineMeetingUrl;
    bool? isOnlineMeeting;
    String? onlineMeetingProvider;
    bool? allowNewTimeProposals;
    String? occurrenceId;
    bool? isDraft;
    bool? hideAttendees;
    Status? responseStatus;
    Body? body;
    MeetDate? start;
    MeetDate? end;
    Location? location;
    List<Location>? locations;
    dynamic recurrence;
    List<Attendee>? attendees;
    Organizer? organizer;
    OnlineMeeting? onlineMeeting;

    Value({
        this.odataEtag,
        this.id,
        this.createdDateTime,
        this.lastModifiedDateTime,
        this.changeKey,
        this.categories,
        this.transactionId,
        this.originalStartTimeZone,
        this.originalEndTimeZone,
        this.iCalUId,
        this.reminderMinutesBeforeStart,
        this.isReminderOn,
        this.hasAttachments,
        this.subject,
        this.bodyPreview,
        this.importance,
        this.sensitivity,
        this.isAllDay,
        this.isCancelled,
        this.isOrganizer,
        this.responseRequested,
        this.seriesMasterId,
        this.showAs,
        this.type,
        this.webLink,
        this.onlineMeetingUrl,
        this.isOnlineMeeting,
        this.onlineMeetingProvider,
        this.allowNewTimeProposals,
        this.occurrenceId,
        this.isDraft,
        this.hideAttendees,
        this.responseStatus,
        this.body,
        this.start,
        this.end,
        this.location,
        this.locations,
        this.recurrence,
        this.attendees,
        this.organizer,
        this.onlineMeeting,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        odataEtag: json["@odata.etag"],
        id: json["id"],
        createdDateTime: json["createdDateTime"] == null ? null : DateTime.parse(json["createdDateTime"]),
        lastModifiedDateTime: json["lastModifiedDateTime"] == null ? null : DateTime.parse(json["lastModifiedDateTime"]),
        changeKey: json["changeKey"],
        categories: json["categories"] == null ? [] : List<dynamic>.from(json["categories"]!.map((x) => x)),
        transactionId: json["transactionId"],
        originalStartTimeZone: json["originalStartTimeZone"],
        originalEndTimeZone: json["originalEndTimeZone"],
        iCalUId: json["iCalUId"],
        reminderMinutesBeforeStart: json["reminderMinutesBeforeStart"],
        isReminderOn: json["isReminderOn"],
        hasAttachments: json["hasAttachments"],
        subject: json["subject"],
        bodyPreview: json["bodyPreview"],
        importance: json["importance"],
        sensitivity: json["sensitivity"],
        isAllDay: json["isAllDay"],
        isCancelled: json["isCancelled"],
        isOrganizer: json["isOrganizer"],
        responseRequested: json["responseRequested"],
        seriesMasterId: json["seriesMasterId"],
        showAs: json["showAs"],
        type: json["type"],
        webLink: json["webLink"],
        onlineMeetingUrl: json["onlineMeetingUrl"],
        isOnlineMeeting: json["isOnlineMeeting"],
        onlineMeetingProvider: json["onlineMeetingProvider"],
        allowNewTimeProposals: json["allowNewTimeProposals"],
        occurrenceId: json["occurrenceId"],
        isDraft: json["isDraft"],
        hideAttendees: json["hideAttendees"],
        responseStatus: json["responseStatus"] == null ? null : Status.fromJson(json["responseStatus"]),
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
        start: json["start"] == null ? null : MeetDate.fromJson(json["start"]),
        end: json["end"] == null ? null : MeetDate.fromJson(json["end"]),
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
        recurrence: json["recurrence"],
        attendees: json["attendees"] == null ? [] : List<Attendee>.from(json["attendees"]!.map((x) => Attendee.fromJson(x))),
        organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
        onlineMeeting: json["onlineMeeting"] == null ? null : OnlineMeeting.fromJson(json["onlineMeeting"]),
    );

    Map<String, dynamic> toJson() => {
        "@odata.etag": odataEtag,
        "id": id,
        "createdDateTime": createdDateTime?.toIso8601String(),
        "lastModifiedDateTime": lastModifiedDateTime?.toIso8601String(),
        "changeKey": changeKey,
        "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x)),
        "transactionId": transactionId,
        "originalStartTimeZone": originalStartTimeZone,
        "originalEndTimeZone": originalEndTimeZone,
        "iCalUId": iCalUId,
        "reminderMinutesBeforeStart": reminderMinutesBeforeStart,
        "isReminderOn": isReminderOn,
        "hasAttachments": hasAttachments,
        "subject": subject,
        "bodyPreview": bodyPreview,
        "importance": importance,
        "sensitivity": sensitivity,
        "isAllDay": isAllDay,
        "isCancelled": isCancelled,
        "isOrganizer": isOrganizer,
        "responseRequested": responseRequested,
        "seriesMasterId": seriesMasterId,
        "showAs": showAs,
        "type": type,
        "webLink": webLink,
        "onlineMeetingUrl": onlineMeetingUrl,
        "isOnlineMeeting": isOnlineMeeting,
        "onlineMeetingProvider": onlineMeetingProvider,
        "allowNewTimeProposals": allowNewTimeProposals,
        "occurrenceId": occurrenceId,
        "isDraft": isDraft,
        "hideAttendees": hideAttendees,
        "responseStatus": responseStatus?.toJson(),
        "body": body?.toJson(),
        "start": start?.toJson(),
        "end": end?.toJson(),
        "location": location?.toJson(),
        "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
        "recurrence": recurrence,
        "attendees": attendees == null ? [] : List<dynamic>.from(attendees!.map((x) => x.toJson())),
        "organizer": organizer?.toJson(),
        "onlineMeeting": onlineMeeting?.toJson(),
    };
}

class Attendee {
    Type? type;
    Status? status;
    EmailAddress? emailAddress;

    Attendee({
        this.type,
        this.status,
        this.emailAddress,
    });

    factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        type: typeValues.map[json["type"]]!,
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        emailAddress: json["emailAddress"] == null ? null : EmailAddress.fromJson(json["emailAddress"]),
    );

    Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "status": status?.toJson(),
        "emailAddress": emailAddress?.toJson(),
    };
}

class EmailAddress {
    String? name;
    String? address;

    EmailAddress({
        this.name,
        this.address,
    });

    factory EmailAddress.fromJson(Map<String, dynamic> json) => EmailAddress(
        name: json["name"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
    };
}

class Status {
    Response? response;
    DateTime? time;

    Status({
        this.response,
        this.time,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        response: responseValues.map[json["response"]]!,
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
    );

    Map<String, dynamic> toJson() => {
        "response": responseValues.reverse[response],
        "time": time?.toIso8601String(),
    };
}

enum Response {
    ACCEPTED,
    NONE,
    NOT_RESPONDED
}

final responseValues = EnumValues({
    "accepted": Response.ACCEPTED,
    "none": Response.NONE,
    "notResponded": Response.NOT_RESPONDED
});

enum Type {
    OPTIONAL,
    REQUIRED
}

final typeValues = EnumValues({
    "optional": Type.OPTIONAL,
    "required": Type.REQUIRED
});

class Body {
    String? contentType;
    String? content;

    Body({
        this.contentType,
        this.content,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        contentType: json["contentType"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "contentType": contentType,
        "content": content,
    };
}

class MeetDate {
    DateTime? dateTime;
    String? timeZone;

    MeetDate({
        this.dateTime,
        this.timeZone,
    });

    factory MeetDate.fromJson(Map<String, dynamic> json) => MeetDate(
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        timeZone: json["timeZone"],
    );

    Map<String, dynamic> toJson() => {
        "dateTime": dateTime?.toIso8601String(),
        "timeZone": timeZone,
    };
}

class Location {
    String? displayName;
    String? locationType;
    String? uniqueId;
    String? uniqueIdType;

    Location({
        this.displayName,
        this.locationType,
        this.uniqueId,
        this.uniqueIdType,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        displayName: json["displayName"],
        locationType: json["locationType"],
        uniqueId: json["uniqueId"],
        uniqueIdType: json["uniqueIdType"],
    );

    Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "locationType": locationType,
        "uniqueId": uniqueId,
        "uniqueIdType": uniqueIdType,
    };
}

class OnlineMeeting {
    String? joinUrl;

    OnlineMeeting({
        this.joinUrl,
    });

    factory OnlineMeeting.fromJson(Map<String, dynamic> json) => OnlineMeeting(
        joinUrl: json["joinUrl"],
    );

    Map<String, dynamic> toJson() => {
        "joinUrl": joinUrl,
    };
}

class Organizer {
    EmailAddress? emailAddress;

    Organizer({
        this.emailAddress,
    });

    factory Organizer.fromJson(Map<String, dynamic> json) => Organizer(
        emailAddress: json["emailAddress"] == null ? null : EmailAddress.fromJson(json["emailAddress"]),
    );

    Map<String, dynamic> toJson() => {
        "emailAddress": emailAddress?.toJson(),
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
