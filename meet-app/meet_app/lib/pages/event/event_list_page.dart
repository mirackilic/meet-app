// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/request/get_meetings_by_roomid_request.dart';
import 'package:meet_app/models/request/get_schedule_by_room_request.dart';
import 'package:meet_app/models/response/get_meeting_rooms_response.dart';
import 'package:meet_app/models/response/get_meetings_by_room.dart';
// import 'package:meet_app/models/response/get_events_response.dart';
import 'package:meet_app/pages/event/calendar_events_page.dart';
import 'package:meet_app/pages/room/room_select_page.dart';
import 'package:meet_app/services/event_service.dart';
// import 'package:shake/shake.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  // String roomId = "ee4ee054-b63a-4120-a42c-51740a899281";
  // String roomName = "Toplantı Odası 601";
  // const EventListPage(
  //     {super.key, required this.roomId, required this.roomName});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  ValueNotifier<String> timerText = ValueNotifier<String>('00:00:00');
  Timer? _timer;
  Timer? _newMeetingsTimer;
  MeetingRooms? meetingRoom;
  bool _isLoading = false;
  ValueNotifier<List<Meeting>>? _selectedEvents;
  Meeting? _currentMeeting;
  Meeting? _nextMeeting;
  // Map<DateTime, List<Event>>? _allEvents = {};
  // List<Event>? _weeklyEvents;
  List<Meeting>? _meetings;
  late String _timeString;
  // DateTime _focusedDay = DateTime.now()c;
  DateTime? _selectedDay;
  bool isTimerCanceled = false;
  String imageUrl =
      "https://aymrkprodimages.blob.core.windows.net/aymrkprodimages/metting/green.jpg";
  String statusText = "MÜSAİT";
  bool isShowTimer = false;
  Color timerBgColor = const Color.fromARGB(255, 164, 108, 44).withOpacity(0.8);
  Color subjectColor = const Color.fromARGB(255, 93, 168, 127);
  bool showMeetInfo = false;
  // final CalendarFormat _calendarFormat = CalendarFormat.month;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date

  @override
  void initState() {
    _timeString = formatMainHour(DateTime.now());

    _selectedDay = DateTime.now();
    _getEvents(_selectedDay!);
    checkNewMeetings();
    // Timer.periodic(const Duration(seconds: 10), (Timer t) => _getTimeString());
    super.initState();
  }

  _getTimeString() {
    final DateTime now = DateTime.now();
    final String formattedTime = formatMainHour(now);

    setState(() {
      _timeString = formattedTime;
    });
  }

  _getEvents(DateTime day) async {
    timerText.value = '00:00:00';
    final prefs = await SharedPreferences.getInstance();
    var selectedRoom = prefs.getString("selectedRoom");

    Map<String, dynamic> meetingRoomMap = jsonDecode(selectedRoom!);
    meetingRoom = MeetingRooms.fromJson(meetingRoomMap);

    try {
      setState(() {
        _isLoading = true;
      });
      await _getAllEvents(_selectedDay!);

      // await _getAllEvents(_selectedDay!);
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      _currentMeeting = findCurrentMeeting(_selectedEvents!);

      if (_currentMeeting != null) {
        _nextMeeting = null;
        final duration =
            _currentMeeting!.end!.dateTime!.difference(DateTime.now());

        if (_meetings!.indexOf(_currentMeeting!) > 0)
          _meetings!.removeRange(0, _meetings!.indexOf(_currentMeeting!) - 1);

        startTimer(duration);
      } else {
        _currentMeeting = null;
        _nextMeeting = findNextMeeting(_selectedEvents!);
        if (_nextMeeting != null) {
          final duration =
              _nextMeeting!.start!.dateTime!.difference(DateTime.now());

          if (_meetings!.indexOf(_nextMeeting!) > 1)
            _meetings!.removeRange(0, _meetings!.indexOf(_nextMeeting!) - 1);

          startTimer(duration);
        }
      }
      // getImageByMeetingStatus();
      setState(() {});
    } catch (e) {
      // buildRequestFailedAlert(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _getEventsNoLoader(DateTime day) async {
    timerText.value = '00:00:00';
    final prefs = await SharedPreferences.getInstance();
    var selectedRoom = prefs.getString("selectedRoom");

    Map<String, dynamic> meetingRoomMap = jsonDecode(selectedRoom!);
    meetingRoom = MeetingRooms.fromJson(meetingRoomMap);

    try {
      // setState(() {
      //   _isLoading = true;
      // });
      _selectedDay = DateTime.now();
      await _getAllEvents(_selectedDay!);

      // await _getAllEvents(_selectedDay!);
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      _currentMeeting = findCurrentMeeting(_selectedEvents!);

      if (_currentMeeting != null) {
        _nextMeeting = null;
        final duration =
            _currentMeeting!.end!.dateTime!.difference(DateTime.now());

        if (_meetings!.indexOf(_currentMeeting!) > 0)
          _meetings!.removeRange(0, _meetings!.indexOf(_currentMeeting!) - 1);

        startTimer(duration);
      } else {
        _currentMeeting = null;
        _nextMeeting = findNextMeeting(_selectedEvents!);
        if (_nextMeeting != null) {
          final duration =
              _nextMeeting!.start!.dateTime!.difference(DateTime.now());

          if (_meetings!.indexOf(_nextMeeting!) > 1)
            _meetings!.removeRange(0, _meetings!.indexOf(_nextMeeting!) - 1);

          startTimer(duration);
        }
      }
      getImageByMeetingStatus();
      setState(() {});
    } catch (e) {
      // buildRequestFailedAlert(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Meeting> _getEventsForDay(DateTime day) {
    if (_meetings == null || _meetings!.isEmpty) return [];
    _meetings = _meetings!
        .where((element) =>
            element.start!.dateTime!.month == day.month &&
            element.start!.dateTime!.day == day.day)
        .toList();

    return _meetings!;
  }

  _getAllEvents(DateTime day) async {
    // Bugünden 7 gün önce ve sonrasını hesapla
    // DateTime sevenDaysAgo = _selectedDay!.subtract(const Duration(days: 7));
    // DateTime sevenDaysAfter = _selectedDay!.add(const Duration(days: 7));
    DateTime firstDate = DateTime(
        _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 0, 1, 0);

    DateTime secondDate = DateTime(
        _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 23, 59, 59);

    String formattedSevenDaysAgo = formatDateForCalendar(firstDate);
    String formattedSevenDaysAfter = formatDateForCalendar(secondDate);

    // try {
    // setState(() {
    //   _isLoading = true;
    // });
    _meetings = await EventService().getMeetings(GetMeetingsByRoomIdRequest(
      roomId: meetingRoom!.graphId!,
      startTime: Time(dateTime: formattedSevenDaysAgo, timeZone: "UTC"),
      endTime: Time(dateTime: formattedSevenDaysAfter, timeZone: "UTC"),
    ));

    // var currentMeet = findCurrentMeeting()

    _meetings!.sort((a, b) =>
        a.start!.dateTime.toString()!.compareTo(b.start!.dateTime.toString()));

    setState(() {});
    // } catch (e) {
    //   buildRequestFailedAlert(context);
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  // Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
  //   if (!isSameDay(_selectedDay, selectedDay)) {
  //     setState(() {
  //       _selectedDay = selectedDay;
  //       _focusedDay = focusedDay;
  //       _rangeStart = null; // Important to clean those
  //       _rangeEnd = null;
  //       _rangeSelectionMode = RangeSelectionMode.toggledOff;
  //       _selectedEvents!.value = _getEventsForDay(selectedDay);
  //     });
  //   }
  // }

  // Future<void> _launchInBrowser(String url) async {
  //   var uri = Uri.parse(url);
  //   if (!await launchUrl(
  //     uri,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  void startTimer(Duration duration) {
    _selectedDay = DateTime.now();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getTimeString();
      final remainingTime = duration - Duration(seconds: timer.tick);
      if (remainingTime.inSeconds <= 0) {
        _getEventsNoLoader(_selectedDay!);

        timer.cancel();
        timerText.value = '00:00:00';
      } else {
        final secondsLeft = duration - Duration(seconds: timer.tick);

        if (secondsLeft.inSeconds <= 15 * 60 && _nextMeeting != null) //15dk
        {
          _nextMeeting!.isWaiting = true;
        }

        final hours =
            remainingTime.inHours.remainder(24).toString().padLeft(2, '0');
        final minutes =
            remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds =
            remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
        timerText.value = '$hours:$minutes:$seconds';
      }

      getImageByMeetingStatus();
    });
  }

  void checkNewMeetings() {
    _newMeetingsTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _timer?.cancel();
      _timeString = formatMainHour(DateTime.now());

      _selectedDay = DateTime.now();
      _getEventsNoLoader(_selectedDay!);
    });
  }

  getImageByMeetingStatus() {
    if (_currentMeeting != null) {
      imageUrl =
          "https://aymrkprodimages.blob.core.windows.net/aymrkprodimages/metting/red.jpg";
      statusText = "MEŞGUL";
      isShowTimer = true;
      timerBgColor = mainColor.withOpacity(0.8);
      showMeetInfo = true;
      subjectColor = const Color.fromARGB(255, 179, 22, 76);
    } else if (_nextMeeting != null && _nextMeeting!.isWaiting) {
      imageUrl =
          "https://aymrkprodimages.blob.core.windows.net/aymrkprodimages/metting/yellow.jpg";
      statusText = "BEKLENİYOR";
      isShowTimer = true;
      timerBgColor = const Color.fromARGB(255, 64, 116, 84).withOpacity(0.8);
      showMeetInfo = true;
      subjectColor = const Color.fromARGB(255, 234, 166, 55);
    } else {
      imageUrl =
          "https://aymrkprodimages.blob.core.windows.net/aymrkprodimages/metting/green.jpg";
      statusText = "MÜSAİT";
      isShowTimer = false;
      timerBgColor = const Color.fromARGB(255, 164, 108, 44).withOpacity(0.8);
      showMeetInfo = false;
      subjectColor = const Color.fromARGB(255, 93, 168, 127);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        // automaticallyImplyLeading: showBackButton,
        leading: Container(),
        backgroundColor: const Color.fromARGB(255, 36, 44, 60),
        elevation: 4.0,
        title: Text(
          meetingRoom == null ? "" : meetingRoom!.name!,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onLongPress: () {
                _timer?.cancel();
                _newMeetingsTimer?.cancel();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RoomSelectPage()));
              },
              child: const Text(
                'Beymen Group',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            height: 40,
            width: 45,
            // padding: const EdgeInsets.all(),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15)),
            child: IconButton(
              icon: const Icon(
                Icons.calendar_month_rounded,
                color: Colors.white,
                size: 25,
              ),
              tooltip: 'Open shopping cart',
              onPressed: () {
                _timer?.cancel();
                _newMeetingsTimer?.cancel();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CalendarEventsPage()));
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: beymenGold,
              ),
            )
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    double screenHeight = MediaQuery.of(context).size.height;
    var meeting = _currentMeeting == null ? _nextMeeting : _currentMeeting;

    return RefreshIndicator(
      onRefresh: () async {
        _timer?.cancel();
        // _newMeetingsTimer?.cancel();
        _timeString = formatMainHour(DateTime.now());

        _selectedDay = DateTime.now();
        await _getEvents(_selectedDay!);
      },
      child: Row(
        children: [
          showMeetInfo == null
              ? CircularProgressIndicator(
                  color: beymenGold,
                )
              : SizedBox(
                  height: screenHeight,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Stack(
                    children: [
                      Container(
                        height: screenHeight,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                            // color: Colors.pinkAccent,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                // colorFilter: ColorFilter.mode(
                                //     Colors.black.withOpacity(0.2),
                                //     BlendMode.dstATop),
                                image: NetworkImage(
                                  imageUrl,
                                ))),
                        child: Container(),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.08),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$_timeString ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: Text(
                                formatDateForImage(DateTime.now()),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// MEŞGUL - MÜSAİT

                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.17),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              statusText,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      /// Timer
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.29),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              maxRadius: screenHeight * 0.13,
                              backgroundColor: timerBgColor,
                              child: isShowTimer
                                  ? ValueListenableBuilder(
                                      valueListenable: timerText,
                                      builder: (context, String value, child) {
                                        return FittedBox(
                                          child: Text(
                                            value,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      },
                                    )
                                  : const FaIcon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                      size: 120,
                                    ),
                            )
                          ],
                        ),
                      ),

                      /// Subject
                      !showMeetInfo
                          ? Container()
                          : Container(
                              alignment: Alignment.bottomCenter,
                              margin:
                                  EdgeInsets.only(bottom: screenHeight * 0.26),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _currentMeeting != null ||
                                          _nextMeeting != null
                                      ? Container(
                                          alignment: Alignment.bottomCenter,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          padding: EdgeInsets.only(
                                              left: 30, right: 30),
                                          child: Text(
                                            _currentMeeting == null
                                                ? _nextMeeting!.subject ?? ""
                                                : _currentMeeting!.subject ??
                                                    "",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),

                      /// Organizer
                      !showMeetInfo
                          ? Container()
                          : Container(
                              alignment: Alignment.bottomCenter,
                              margin:
                                  EdgeInsets.only(bottom: screenHeight * 0.21),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _currentMeeting != null ||
                                          _nextMeeting != null
                                      ? RichText(
                                          text: TextSpan(children: [
                                          const TextSpan(
                                            text: "Organizer:",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                          TextSpan(
                                              text:
                                                  " ${_currentMeeting == null ? _nextMeeting!.organizer?.emailAddress?.name! : _currentMeeting!.organizer?.emailAddress?.name!}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 23))
                                        ]))
                                      : Container()
                                ],
                              ),
                            ),

                      ///Start - End time
                      !showMeetInfo
                          ? Container()
                          : _currentMeeting == null && _nextMeeting == null
                              ? Container()
                              : Container(
                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.only(
                                      bottom: screenHeight * 0.15),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 21),
                                        child: Row(
                                          children: [
                                            Text(
                                                "${formatDateForScheduleList(meeting!.start!.dateTime!)} ",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23)),
                                            const Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            Text(
                                                " ${formatDateForScheduleList(meeting.end!.dateTime!)}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 23)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                    ],
                  ),
                ),
          _selectedEvents == null
              ? Container()
              : Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 30,
                      color: Colors.grey.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, left: 15),
                        child: Text(
                          'Bugün',
                          // textAlign: TextAlign.justify,
                          // formatDateForCreateMeet(_selectedDay!),
                          style: TextStyle(color: mainColor, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: ValueListenableBuilder<List<Meeting>>(
                        valueListenable: _selectedEvents!,
                        builder: (context, value, _) {
                          return ListView.builder(
                            shrinkWrap: false,
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                minVerticalPadding: 0,
                                subtitle: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 30),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "${formatDateForScheduleList(value[index].start!.dateTime!)} ",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22)),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                              Text(
                                                  " ${formatDateForScheduleList(value[index].end!.dateTime!)}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          // margin:
                                          //     const EdgeInsets.only(left: 22),
                                          child: Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: [
                                                    value[index] == meeting
                                                        ? Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .play,
                                                                color: value[
                                                                            index] ==
                                                                        meeting
                                                                    ? subjectColor
                                                                    : Colors
                                                                        .black,
                                                                size: 35,
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox(
                                                            width: 32,
                                                          ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                      child: Text(
                                                          "${value[index].subject} ",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: value[
                                                                          index] ==
                                                                      meeting
                                                                  ? subjectColor
                                                                  : Colors
                                                                      .black,
                                                              fontSize: 26,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Expanded(
                                              //   flex: 1,
                                              //   child: Container(
                                              //     alignment: Alignment.center,
                                              //     // width: MediaQuery.of(context)
                                              //     //         .size
                                              //     //         .width *
                                              //     //     0.2,
                                              //     child: Text(
                                              //         value[index] ==
                                              //                 findCurrentMeeting(
                                              //                     _selectedEvents!)
                                              //             ? "LIVE "
                                              //             : value[index] ==
                                              //                     findNextMeeting(
                                              //                         _selectedEvents!)
                                              //                 ? "NEXT"
                                              //                 : "",
                                              //         overflow:
                                              //             TextOverflow.ellipsis,
                                              //         style: const TextStyle(
                                              //             color: Colors.red,
                                              //             fontSize: 20,
                                              //             fontWeight:
                                              //                 FontWeight.bold)),
                                              //   ),
                                              // ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 9),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                mainColor)),
                                                    onPressed: () {
                                                      var attendees =
                                                          value[index]
                                                              .attendees;
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            contextt) {
                                                          return AlertDialog(
                                                            title: const Column(
                                                              children: [
                                                                Text(
                                                                    'Katılımcılar'),
                                                                Divider()
                                                              ],
                                                            ),
                                                            content: SizedBox(
                                                              height: 300,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              child: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: value[
                                                                        index]
                                                                    .attendees
                                                                    ?.length,
                                                                itemBuilder:
                                                                    (context,
                                                                        indexx) {
                                                                  var attendee =
                                                                      attendees![
                                                                          indexx];
                                                                  return Column(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                16),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: MediaQuery.of(context).size.width * 0.48,
                                                                              child: Text(attendee.emailAddress!.name!, overflow: TextOverflow.ellipsis, style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            5,
                                                                      )
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      backgroundColor:
                                                                          MaterialStatePropertyAll(
                                                                              mainColor)),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: const Text(
                                                                      "Tamam",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)))
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        value[index].attendees ==
                                                                null
                                                            ? Container()
                                                            : Text(
                                                                "+ ${value[index].attendees!.length} ",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                        const Icon(
                                                          Icons.person_rounded,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    )),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 33),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "${value[index].organizer!.emailAddress!.name} ",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 116, 115, 115),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 0,
                                          height: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
