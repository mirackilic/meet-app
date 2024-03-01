import 'dart:convert';
import 'package:meet_app/helpers/request_helper.dart';
import 'package:meet_app/models/request/create_meet_request.dart';
import 'package:meet_app/models/request/get_schedule_by_room_request.dart';
import 'package:meet_app/models/response/get_events_response.dart';
import 'package:meet_app/models/response/get_schedule_byroom_response.dart';

class EventService {
  Future<List<Event>> getByCalendarId(
      String id, String startDate, String endDate) async {
    var response = await RequestHelper.sendRequest("GET",
        "me/calendars/$id/calendarView?startdatetime=$startDate&enddatetime=$endDate");

    var list = jsonDecode(response.body);
    var result = List<Event>.from(list["value"].map((x) => Event.fromJson(x)));

    return result;
  }

  Future<List<Meetings>> getScheduleByRoom(
      GetScheduleByRoomRequest request) async {
    var response = await RequestHelper.sendRequest(
        "POST", "/me/calendar/getSchedule",
        body: request.toJson());

    var list = jsonDecode(response.body);
    var result =
        List<Meetings>.from(list["value"].map((x) => Meetings.fromJson(x)));

    return result;
  }

  Future<bool> create(CreateMeetRequest request, String calendarId) async {
    var response = await RequestHelper.sendRequest(
        "POST", "me/calendars/$calendarId/events",
        body: request.toJson());

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
