import 'package:meet_app/models/request/get_schedule_by_room_request.dart';

class GetMeetingsByRoomIdRequest {
  String roomId;
  Time? startTime;
  Time? endTime;

  GetMeetingsByRoomIdRequest(
      {required this.roomId, this.startTime, this.endTime});
}
