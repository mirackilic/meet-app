// ignore_for_file: unrelated_type_equality_checks
import 'dart:convert';
import 'package:meet_app/helpers/request_helper.dart';
import 'package:meet_app/models/request/create_calendar_request.dart';
import 'package:meet_app/models/response/get_calendars_response.dart';

class CalendarService {
  Future<List<Calendar>> get() async {
    var response = await RequestHelper.sendRequest("GET", "me/calendars");

    var list = jsonDecode(response.body);
    var result =
        List<Calendar>.from(list["value"].map((x) => Calendar.fromJson(x)));

    return result;
  }

  Future<bool> create(CreateCalendarRequest request) async {
    var response = await RequestHelper.sendRequest("POST", "me/calendars",
        body: request.toJson());

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
