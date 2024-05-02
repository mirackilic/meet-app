import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:meet_app/helpers/request_helper.dart';
import 'package:meet_app/models/response/get_meeting_rooms_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<List<MeetingRooms>> getRooms() async {
    var response = await RequestHelper.sendRequest(
        "GET", "MeetingRoom?Offset=0&Limit=150");

    var list = jsonDecode(response.body);
    var result = List<MeetingRooms>.from(
        list["data"].map((x) => MeetingRooms.fromJson(x)));

    return result;
  }
}
