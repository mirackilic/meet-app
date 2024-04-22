// To parse this JSON data, do
//
//     final getMeetingsByRoomResponse = getMeetingsByRoomResponseFromJson(jsonString);

import 'dart:convert';

GetMeetingsByRoomResponse getMeetingsByRoomResponseFromJson(String str) => GetMeetingsByRoomResponse.fromJson(json.decode(str));

String getMeetingsByRoomResponseToJson(GetMeetingsByRoomResponse data) => json.encode(data.toJson());

class GetMeetingsByRoomResponse {
    String? odataContext;
    List<Meeting>? value;

    GetMeetingsByRoomResponse({
        this.odataContext,
        this.value,
    });

    factory GetMeetingsByRoomResponse.fromJson(Map<String, dynamic> json) => GetMeetingsByRoomResponse(
        odataContext: json["@odata.context"],
        value: json["value"] == null ? [] : List<Meeting>.from(json["value"]!.map((x) => Meeting.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "@odata.context": odataContext,
        "value": value == null ? [] : List<dynamic>.from(value!.map((x) => x.toJson())),
    };
}

class Meeting {
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
    dynamic seriesMasterId;
    String? showAs;
    String? type;
    String? webLink;
    dynamic onlineMeetingUrl;
    bool? isOnlineMeeting;
    String? onlineMeetingProvider;
    bool? allowNewTimeProposals;
    dynamic occurrenceId;
    bool? isDraft;
    bool? hideAttendees;
    Status? responseStatus;
    Body? body;
    End? start;
    End? end;
    PurpleLocation? location;
    List<LocationElement>? locations;
    dynamic recurrence;
    List<Attendee>? attendees;
    Organizer? organizer;
    OnlineMeeting? onlineMeeting;
    String? calendarOdataAssociationLink;
    String? calendarOdataNavigationLink;

    Meeting({
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
        this.calendarOdataAssociationLink,
        this.calendarOdataNavigationLink,
    });

    factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
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
        start: json["start"] == null ? null : End.fromJson(json["start"]),
        end: json["end"] == null ? null : End.fromJson(json["end"]),
        location: json["location"] == null ? null : PurpleLocation.fromJson(json["location"]),
        locations: json["locations"] == null ? [] : List<LocationElement>.from(json["locations"]!.map((x) => LocationElement.fromJson(x))),
        recurrence: json["recurrence"],
        attendees: json["attendees"] == null ? [] : List<Attendee>.from(json["attendees"]!.map((x) => Attendee.fromJson(x))),
        organizer: json["organizer"] == null ? null : Organizer.fromJson(json["organizer"]),
        onlineMeeting: json["onlineMeeting"] == null ? null : OnlineMeeting.fromJson(json["onlineMeeting"]),
        calendarOdataAssociationLink: json["calendar@odata.associationLink"],
        calendarOdataNavigationLink: json["calendar@odata.navigationLink"],
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
        "calendar@odata.associationLink": calendarOdataAssociationLink,
        "calendar@odata.navigationLink": calendarOdataNavigationLink,
    };
}

class Attendee {
    String? type;
    Status? status;
    EmailAddress? emailAddress;

    Attendee({
        this.type,
        this.status,
        this.emailAddress,
    });

    factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        type: json["type"],
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        emailAddress: json["emailAddress"] == null ? null : EmailAddress.fromJson(json["emailAddress"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
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
    String? response;
    DateTime? time;

    Status({
        this.response,
        this.time,
    });

    factory Status.fromJson(Map<String, dynamic> json) => Status(
        response: json["response"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response,
        "time": time?.toIso8601String(),
    };
}

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

class End {
    DateTime? dateTime;
    String? timeZone;

    End({
        this.dateTime,
        this.timeZone,
    });

    factory End.fromJson(Map<String, dynamic> json) => End(
        dateTime: json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        timeZone: json["timeZone"],
    );

    Map<String, dynamic> toJson() => {
        "dateTime": dateTime?.toIso8601String(),
        "timeZone": timeZone,
    };
}

class PurpleLocation {
    String? displayName;
    String? locationType;
    String? uniqueId;
    String? uniqueIdType;

    PurpleLocation({
        this.displayName,
        this.locationType,
        this.uniqueId,
        this.uniqueIdType,
    });

    factory PurpleLocation.fromJson(Map<String, dynamic> json) => PurpleLocation(
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

class LocationElement {
    String? displayName;
    String? locationUri;
    String? locationType;
    String? uniqueId;
    String? uniqueIdType;
    Address? address;
    Coordinates? coordinates;

    LocationElement({
        this.displayName,
        this.locationUri,
        this.locationType,
        this.uniqueId,
        this.uniqueIdType,
        this.address,
        this.coordinates,
    });

    factory LocationElement.fromJson(Map<String, dynamic> json) => LocationElement(
        displayName: json["displayName"],
        locationUri: json["locationUri"],
        locationType: json["locationType"],
        uniqueId: json["uniqueId"],
        uniqueIdType: json["uniqueIdType"],
        address: json["address"] == null ? null : Address.fromJson(json["address"]),
        coordinates: json["coordinates"] == null ? null : Coordinates.fromJson(json["coordinates"]),
    );

    Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "locationUri": locationUri,
        "locationType": locationType,
        "uniqueId": uniqueId,
        "uniqueIdType": uniqueIdType,
        "address": address?.toJson(),
        "coordinates": coordinates?.toJson(),
    };
}

class Address {
    String? street;
    String? city;
    String? state;
    String? countryOrRegion;
    String? postalCode;

    Address({
        this.street,
        this.city,
        this.state,
        this.countryOrRegion,
        this.postalCode,
    });

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        countryOrRegion: json["countryOrRegion"],
        postalCode: json["postalCode"],
    );

    Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "countryOrRegion": countryOrRegion,
        "postalCode": postalCode,
    };
}

class Coordinates {
    Coordinates();

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    );

    Map<String, dynamic> toJson() => {
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
