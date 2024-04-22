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
  late Timer _newMeetingsTimer;
  MeetingRooms? meetingRoom;
  bool _isLoading = false;
  ValueNotifier<List<Meeting>>? _selectedEvents;
  Meeting? _currentMeeting;
  Meeting? _nextMeeting;
  // Map<DateTime, List<Event>>? _allEvents = {};
  // List<Event>? _weeklyEvents;
  List<Meeting>? _meetings;
  late String _timeString;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool isTimerCanceled = false;
  // final CalendarFormat _calendarFormat = CalendarFormat.month;
  // RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
  //     .toggledOff; // Can be toggled on/off by longpressing a date

  @override
  void initState() {
    // ShakeDetector detector = ShakeDetector.autoStart(
    //   onPhoneShake: () {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Shake!'),
    //       ),
    //     );
    //     // Do stuff on phone shake
    //   },
    //   minimumShakeCount: 1,
    //   shakeSlopTimeMS: 500,
    //   shakeCountResetTime: 3000,
    //   shakeThresholdGravity: 2.7,
    // );
    _timeString = formatMainHour(DateTime.now());

    _selectedDay = _focusedDay;
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
    checkNewMeetings();
    final prefs = await SharedPreferences.getInstance();
    var selectedRoom = prefs.getString("selectedRoom");

    Map<String, dynamic> meetingRoomMap = jsonDecode(selectedRoom!);
    meetingRoom = MeetingRooms.fromJson(meetingRoomMap);

    await _getAllEvents(_selectedDay!);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _currentMeeting = findCurrentMeeting(_selectedEvents!);

    if (_currentMeeting != null) {
      final duration =
          _currentMeeting!.end!.dateTime!.difference(DateTime.now());

      _meetings!.removeRange(0, _meetings!.indexOf(_currentMeeting!) - 1);
      startTimer(duration);
    } else {
      _nextMeeting = findNextMeeting(_selectedEvents!);
      if (_nextMeeting != null) {
        final duration =
            _nextMeeting!.start!.dateTime!.difference(DateTime.now());

        _meetings!.removeRange(0, _meetings!.indexOf(_nextMeeting!) - 1);

        startTimer(duration);
      }
    }

    setState(() {});
  }

  List<Meeting> _getEventsForDay(DateTime day) {
    if (_meetings == null || _meetings!.isEmpty) return [];
    _meetings = _meetings!
        .where((element) =>
            element.start!.dateTime!.month == day.month &&
            element.start!.dateTime!.day == day.day)
        .toList();

    // _meetings![1].start!.dateTime = DateTime(2024, 12, 22, 7, 39);

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

    try {
      setState(() {
        _isLoading = true;
      });
      // _weeklyEvents = await EventService().getByCalendarId(
      //     widget.calendarId, formattedSevenDaysAgo, formattedSevenDaysAfter);

      _meetings = await EventService().getMeetings(GetMeetingsByRoomIdRequest(
        roomId: meetingRoom!.graphId!,
        startTime: Time(dateTime: formattedSevenDaysAgo, timeZone: "UTC"),
        endTime: Time(dateTime: formattedSevenDaysAfter, timeZone: "UTC"),
      ));

      // var currentMeet = findCurrentMeeting()

      _meetings!.sort((a, b) => a.start!.dateTime
          .toString()!
          .compareTo(b.start!.dateTime.toString()));

      setState(() {});
    } catch (e) {
      buildRequestFailedAlert(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getTimeString();
      final remainingTime = duration - Duration(seconds: timer.tick);
      if (remainingTime.inSeconds <= 0) {
        _getEvents(_selectedDay!);

        timer.cancel();
        timerText.value = '00:00:00';
      } else {
        final hours =
            remainingTime.inHours.remainder(24).toString().padLeft(2, '0');
        final minutes =
            remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
        final seconds =
            remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');
        timerText.value = '$hours:$minutes:$seconds';
      }
    });
  }

  void checkNewMeetings() {
    _newMeetingsTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _timer?.cancel();
      _timeString = formatMainHour(DateTime.now());

      _selectedDay = _focusedDay;
      _getEvents(_selectedDay!);
    });
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
                _newMeetingsTimer.cancel();
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
                _newMeetingsTimer.cancel();
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
        _newMeetingsTimer.cancel();
        _timeString = formatMainHour(DateTime.now());

        _selectedDay = _focusedDay;
        await _getEvents(_selectedDay!);
      },
      child: Row(
        children: [
          SizedBox(
            height: screenHeight,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: const AssetImage(
                            'assets/images/everest.jpg',
                          ))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.dstATop),
                            image: const AssetImage(
                              'assets/images/everest.jpg',
                            ))),
                    child: Container(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.145),
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
                  margin: EdgeInsets.only(top: screenHeight * 0.25),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${_currentMeeting != null ? 'MEŞGUL' : 'MÜSAİT'} ",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                /// Timer
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.36),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          maxRadius: screenHeight * 0.13,
                          backgroundColor: _currentMeeting == null
                              ? Colors.green.withOpacity(0.7)
                              : mainColor,
                          child: ValueListenableBuilder(
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
                          ))
                    ],
                  ),
                ),

                /// Subject
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.22),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentMeeting != null || _nextMeeting != null
                          ? Text(
                              _currentMeeting == null
                                  ? _nextMeeting!.subject ?? ""
                                  : _currentMeeting!.subject ?? "",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                    ],
                  ),
                ),

                /// Organizer
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.18),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _currentMeeting != null || _nextMeeting != null
                          ? RichText(
                              text: TextSpan(children: [
                              const TextSpan(
                                text: "Organizer:",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
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

                // Container(
                //   alignment: Alignment.bottomCenter,
                //   margin: EdgeInsets.only(bottom: screenHeight * 0.18),
                //   width: MediaQuery.of(context).size.width * 0.6,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       _currentMeeting != null || _nextMeeting != null
                //           ? Text(
                //               " ${_currentMeeting == null ? _nextMeeting!.organizer?.emailAddress?.name! : _currentMeeting!.organizer?.emailAddress?.name!}",
                //               style: const TextStyle(
                //                   fontWeight: FontWeight.bold,
                //                   color: Colors.white,
                //                   fontSize: 23),
                //             )
                //           : Container(),
                //     ],
                //   ),
                // ),

                ///Start - End time
                _currentMeeting == null && _nextMeeting == null
                    ? Container()
                    : Container(
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.14),
                        width: MediaQuery.of(context).size.width * 0.6,
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
                                          color: Colors.white, fontSize: 23)),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Text(
                                      " ${formatDateForScheduleList(meeting.end!.dateTime!)}",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 23)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                // _currentMeeting == null && _nextMeeting == null
                //     ? Container()
                //     : Container(
                //         alignment: Alignment.bottomCenter,
                //         margin: EdgeInsets.only(bottom: screenHeight * 0.05),
                //         width: MediaQuery.of(context).size.width * 0.6,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             SizedBox(
                //               width: MediaQuery.of(context).size.width * 0.2,
                //               height: 40,
                //               child: ElevatedButton(
                //                   style: ButtonStyle(
                //                       backgroundColor:
                //                           MaterialStatePropertyAll(mainColor)),
                //                   onPressed: () {
                //                     showDialog(
                //                       context: context,
                //                       builder: (BuildContext contextt) {
                //                         return AlertDialog(
                //                           title: const Column(
                //                             children: [
                //                               Text('Katılımcılar'),
                //                               Divider()
                //                             ],
                //                           ),
                //                           content: Container(
                //                             height: 200,
                //                             width: 200,
                //                             child: ListView.builder(
                //                               shrinkWrap: true,
                //                               itemCount:
                //                                   meeting?.attendees?.length,
                //                               itemBuilder: (context, index) {
                //                                 var attendee =
                //                                     meeting!.attendees![index];
                //                                 return Column(
                //                                   children: [
                //                                     Container(
                //                                       margin:
                //                                           const EdgeInsets.only(
                //                                               left: 16),
                //                                       child: Row(
                //                                         mainAxisAlignment:
                //                                             MainAxisAlignment
                //                                                 .start,
                //                                         children: [
                //                                           Text(
                //                                               attendee
                //                                                   .emailAddress!
                //                                                   .name!,
                //                                               style: TextStyle(
                //                                                   color:
                //                                                       mainColor,
                //                                                   fontSize: 18,
                //                                                   fontWeight:
                //                                                       FontWeight
                //                                                           .bold)),
                //                                         ],
                //                                       ),
                //                                     ),
                //                                     const SizedBox(
                //                                       height: 5,
                //                                     )
                //                                   ],
                //                                 );
                //                               },
                //                             ),
                //                           ),
                //                           actions: [
                //                             ElevatedButton(
                //                                 style: ButtonStyle(
                //                                     backgroundColor:
                //                                         MaterialStatePropertyAll(
                //                                             mainColor)),
                //                                 onPressed: () =>
                //                                     Navigator.pop(context),
                //                                 child: const Text("Tamam",
                //                                     style: TextStyle(
                //                                         color: Colors.white)))
                //                           ],
                //                         );
                //                       },
                //                     );
                //                   },
                //                   child: const Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                           "Katılımcılar ", //  |  ${meeting!.attendees!.length}
                //                           style: TextStyle(
                //                               color: Colors.white,
                //                               fontSize: 21)),
                //                       Icon(
                //                         Icons.person,
                //                         color: Colors.white,
                //                       )
                //                     ],
                //                   )),
                //             )
                //             // Text(
                //             // 3 _currentMeeting == null
                //             //       ? _nextMeeting!.location!
                //             //       : _currentMeeting!.location!,
                //             //   style: const TextStyle(
                //             //       color: Colors.white,
                //             //       fontSize: 35,
                //             //       fontFamily: AutofillHints.addressCity),
                //             // 61
                //           ],
                //         ),
                //       ),
              ],
            ),
          ),
          // Container(
          //   color: mainColor,
          //   width: MediaQuery.of(context).size.width * 0.6,
          //   child: TableCalendar<ScheduleItem>(
          //     // rowHeight: 40,
          //     locale: "tr_TR",
          //     daysOfWeekStyle: const DaysOfWeekStyle(
          //       weekdayStyle:
          //           TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          //     ),
          //     firstDay: DateTime.now().add(const Duration(days: -7)),
          //     lastDay: DateTime.now().add(const Duration(days: 7)),
          //     focusedDay: _focusedDay,
          //     selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          //     rangeStartDay: _rangeStart,
          //     rangeEndDay: _rangeEnd,
          //     calendarFormat: _calendarFormat,
          //     rangeSelectionMode: _rangeSelectionMode,
          //     eventLoader: _getEventsForDay,
          //     startingDayOfWeek: StartingDayOfWeek.monday,
          //     headerStyle: const HeaderStyle(
          //         titleTextStyle: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.w200,
          //             fontSize: 17)),
          //     calendarStyle: const CalendarStyle(
          //       defaultTextStyle: TextStyle(color: Colors.white),
          //       selectedDecoration:
          //           BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          //       todayDecoration:
          //           BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
          //       markerDecoration:
          //           BoxDecoration(color: Colors.white, shape: BoxShape.circle),

          //       markersMaxCount: 1,
          //       weekNumberTextStyle: TextStyle(color: Colors.white),

          //       // holidayTextStyle: TextStyle(color: Colors.grey),
          //       outsideDaysVisible: false,
          //     ),
          //     onDaySelected: _onDaySelected,
          //     // onRangeSelected: _onRangeSelected,
          //     availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          //     onPageChanged: (focusedDay) {
          //       _focusedDay = focusedDay;
          //     },
          //   ),
          // ),
          // const SizedBox(height: 15),
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
                                              const EdgeInsets.only(left: 21),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "${formatDateForScheduleList(value[index].start!.dateTime!)} ",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                color: Colors.black,
                                                size: 16,
                                              ),
                                              Text(
                                                  " ${formatDateForScheduleList(value[index].end!.dateTime!)}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20)),
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
                                                    value[index] ==
                                                            findCurrentMeeting(
                                                                _selectedEvents!)
                                                        ? Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .play,
                                                                color: Colors
                                                                    .pinkAccent
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                              const SizedBox(
                                                                width: 3,
                                                              )
                                                            ],
                                                          )
                                                        : const SizedBox(
                                                            width: 22,
                                                          ),
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(
                                                            "${value[index].subject} ",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color: value[
                                                                            index] ==
                                                                        findCurrentMeeting(
                                                                            _selectedEvents!)
                                                                    ? Colors
                                                                        .pinkAccent
                                                                    : Colors
                                                                        .black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  // width: MediaQuery.of(context)
                                                  //         .size
                                                  //         .width *
                                                  //     0.2,
                                                  child: Text(
                                                      value[index] ==
                                                              findCurrentMeeting(
                                                                  _selectedEvents!)
                                                          ? "LIVE "
                                                          : value[index] ==
                                                                  findNextMeeting(
                                                                      _selectedEvents!)
                                                              ? "NEXT"
                                                              : "",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
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
                                                              title:
                                                                  const Column(
                                                                children: [
                                                                  Text(
                                                                      'Katılımcılar'),
                                                                  Divider()
                                                                ],
                                                              ),
                                                              content:
                                                                  Container(
                                                                height: 200,
                                                                width: 200,
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
                                                                              left: 16),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(attendee.emailAddress!.name!, style: TextStyle(color: mainColor, fontSize: 18, fontWeight: FontWeight.bold)),
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
                                                      child: const Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .person_rounded,
                                                            color: Colors.white,
                                                          )
                                                        ],
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 22),
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
