// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/request/get_schedule_by_room_request.dart';
import 'package:meet_app/models/response/get_events_response.dart';
import 'package:meet_app/models/response/get_schedule_byroom_response.dart';
import 'package:meet_app/pages/event/add_event_page.dart';
import 'package:meet_app/pages/event/calendar_events_page.dart';
import 'package:meet_app/services/event_service.dart';
import 'package:meet_app/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  final String roomMail;
  final String roomName;
  const EventListPage(
      {super.key, required this.roomMail, required this.roomName});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  ValueNotifier<String> timerText = ValueNotifier<String>('00:00:00');

  bool _isLoading = false;
  ValueNotifier<List<ScheduleItem>>? _selectedEvents;
  ScheduleItem? _currentMeeting;
  ScheduleItem? _nextMeeting;
  // Map<DateTime, List<Event>>? _allEvents = {};
  List<Event>? _weeklyEvents;
  List<Meetings>? _meetings;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _getEvents(_selectedDay!);
  }

  _getEvents(DateTime day) async {
    await _getAllEvents(_selectedDay!);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _currentMeeting = findCurrentMeeting(_selectedEvents!);

    if (_currentMeeting != null) {
      final duration = _currentMeeting!.end!.dateTime!
          .add(const Duration(hours: 3))
          .difference(DateTime.now());
      startTimer(duration);
    } else {
      _nextMeeting = findNextMeeting(_selectedEvents!);
      if (_nextMeeting != null) {
        final duration = _nextMeeting!.start!.dateTime!
            .add(const Duration(hours: 3))
            .difference(DateTime.now());
        startTimer(duration);
      }
    }

    setState(() {});
  }

  List<ScheduleItem> _getEventsForDay(DateTime day) {
    if (_meetings == null || _meetings!.isEmpty) return [];
    return _meetings!.first.scheduleItems!
        .where((element) =>
            element.start!.dateTime!.month == day.month &&
            element.start!.dateTime!.day == day.day)
        .toList();
  }

  _getAllEvents(DateTime day) async {
    // Bugünden 7 gün önce ve sonrasını hesapla
    // DateTime sevenDaysAgo = _selectedDay!.subtract(const Duration(days: 7));
    // DateTime sevenDaysAfter = _selectedDay!.add(const Duration(days: 7));
    DateTime firstDate = DateTime(
        _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 1, 0, 0);

    DateTime secondDate = DateTime(
        _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 21, 00, 00);

    String formattedSevenDaysAgo = formatDateForCalendar(firstDate);
    String formattedSevenDaysAfter = formatDateForCalendar(secondDate);

    try {
      setState(() {
        _isLoading = true;
      });
      // _weeklyEvents = await EventService().getByCalendarId(
      //     widget.calendarId, formattedSevenDaysAgo, formattedSevenDaysAfter);
      _meetings =
          await EventService().getScheduleByRoom(GetScheduleByRoomRequest(
        schedules: [widget.roomMail],
        availabilityViewInterval: 30,
        startTime: Time(dateTime: formattedSevenDaysAgo, timeZone: "UTC"),
        endTime: Time(dateTime: formattedSevenDaysAfter, timeZone: "UTC"),
      ));
      setState(() {});
    } catch (e) {
      buildRequestFailedAlert(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// String _checkMeetings(){
//   if(_currentMeeting == null&& _nextMeeting == null)
//   return 'MÜSAİT';
//   else if(_currentMeeting)
// }

  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents!.value = _getEventsForDay(selectedDay);
      });
    }
  }

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
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final remainingTime = duration - Duration(seconds: timer.tick);
      if (remainingTime.inSeconds <= 0) {
        timer.cancel();
        timerText.value = 'Toplantı sona erdi.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        // automaticallyImplyLeading: showBackButton,
        backgroundColor: const Color.fromARGB(255, 36, 44, 60),
        elevation: 4.0,
        title: Text(
          widget.roomName,
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const Text(
              'Beymen Group',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
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
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CalendarEventsPage(
                          roomMail: widget.roomMail,
                          roomName: widget.roomName))),
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
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
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
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                          image: const AssetImage(
                            'assets/images/everest.jpg',
                          ))),
                  child: Container(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 120),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${formatDateForScheduleList(DateTime.now())} ",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      child: Text(
                        formatDateForImage(DateTime.now()),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 160),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${_currentMeeting != null ? 'MEŞGUL' : 'MÜSAİT'} ",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 250),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        maxRadius: 90,
                        backgroundColor: _currentMeeting == null
                            ? Colors.green.withOpacity(0.7)
                            : mainColor,
                        child: ValueListenableBuilder(
                          valueListenable: timerText,
                          builder: (context, String value, child) {
                            return Text(
                              value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ))
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 470),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _currentMeeting != null || _nextMeeting != null
                        ? Text(
                            "Organizer: ${_currentMeeting == null ? _nextMeeting!.subject! : _currentMeeting!.subject!}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 28),
                          )
                        : Container(),
                  ],
                ),
              ),
              _currentMeeting == null && _nextMeeting == null
                  ? Container()
                  : Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.only(bottom: 30),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 61,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(mainColor)),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext contextt) {
                                      return AlertDialog(
                                        title: const Text('Katılımcılar'),
                                        content: Container(
                                          height: 200,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 2,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("Bekir Habek",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                                color: mainColor,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // const Icon(
                                                    //   Icons.arrow_right_sharp,
                                                    //   color: Colors.pinkAccent,
                                                    //   size: 30,
                                                    // ),
                                                    Text("Sühan Erol",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              Divider(
                                                height: 1,
                                                color: mainColor,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 16),
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // const Icon(
                                                    //   Icons.arrow_right_sharp,
                                                    //   color: Colors.pinkAccent,
                                                    //   size: 30,
                                                    // ),
                                                    Text("Miraç Kılıç",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll(
                                                          mainColor)),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Tamam",
                                                  style: TextStyle(
                                                      color: Colors.white)))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text("Katılımcılar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 23))),
                          )
                          // Text(
                          // 3 _currentMeeting == null
                          //       ? _nextMeeting!.location!
                          //       : _currentMeeting!.location!,
                          //   style: const TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 35,
                          //       fontFamily: AutofillHints.addressCity),
                          // 61
                        ],
                      ),
                    ),
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
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.4,
                child: ValueListenableBuilder<List<ScheduleItem>>(
                  valueListenable: _selectedEvents!,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          minVerticalPadding: 0,
                          // contentPadding: const EdgeInsets.all(5),
                          // onTap: () async =>
                          //     value[index].onlineMeeting == null
                          //         ? null
                          //         : await _launchInBrowser(
                          //             value[index].onlineMeeting!.joinUrl!),
                          // leading: CircleAvatar(
                          //   radius: 20,
                          //   backgroundColor: beymenGold,
                          //   child: Icon(
                          //     Icons.calendar_month_rounded,
                          //     color: mainColor,
                          //     size: 30,
                          //   ),
                          // ),
                          title: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 30,
                            color: Colors.grey.withOpacity(0.5),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2, left: 15),
                              child: Text(
                                'Today',
                                // textAlign: TextAlign.justify,
                                // formatDateForCreateMeet(_selectedDay!),
                                style: TextStyle(
                                  color: mainColor,
                                ),
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    Text(
                                        "${formatDateForScheduleList(value[index].start!.dateTime!)} ",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        )),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.black,
                                      size: 16,
                                    ),
                                    Text(
                                        " ${formatDateForScheduleList(value[index].end!.dateTime!)}",
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // const Icon(
                                    //   Icons.arrow_right_sharp,
                                    //   color: Colors.pinkAccent,
                                    //   size: 30,
                                    // ),
                                    Text("${value[index].location} ",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 16),
                                child: Row(
                                  children: [
                                    Text("${value[index].subject} ",
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 116, 115, 115),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}
