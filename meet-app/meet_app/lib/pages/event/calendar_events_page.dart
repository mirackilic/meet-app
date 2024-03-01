// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/request/get_schedule_by_room_request.dart';
import 'package:meet_app/models/response/get_events_response.dart';
import 'package:meet_app/models/response/get_schedule_byroom_response.dart';
import 'package:meet_app/pages/event/add_event_page.dart';
import 'package:meet_app/services/event_service.dart';
import 'package:meet_app/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:url_launcher/url_launcher.dart';

class CalendarEventsPage extends StatefulWidget {
  final String roomMail;
  final String roomName;
  const CalendarEventsPage(
      {super.key, required this.roomMail, required this.roomName});

  @override
  State<CalendarEventsPage> createState() => _CalendarEventsPageState();
}

class _CalendarEventsPageState extends State<CalendarEventsPage> {
  bool _isLoading = false;
  ValueNotifier<List<ScheduleItem>>? _selectedEvents;
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
    DateTime sevenDaysAgo = _selectedDay!.subtract(const Duration(days: 7));
    DateTime sevenDaysAfter = _selectedDay!.add(const Duration(days: 7));
    // DateTime firstDate = DateTime(
    //     _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 0, 0, 0);

    // DateTime secondDate = DateTime(
    //     _selectedDay!.year, _selectedDay!.month, _selectedDay!.day, 23, 59, 59);

    String formattedSevenDaysAgo = formatDateForCalendar(sevenDaysAgo);
    String formattedSevenDaysAfter = formatDateForCalendar(sevenDaysAfter);

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
        startTime: Time(
            dateTime: formattedSevenDaysAgo, timeZone: "UTC"),
        endTime: Time(
            dateTime: formattedSevenDaysAfter,
            timeZone: "UTC"),
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
            margin: const EdgeInsets.only(right: 20),
            child: const Text(
              'Beymen Group',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.add,
          //     color: Colors.white,
          //   ),
          //   tooltip: 'Open shopping cart',
          //   onPressed: null,
          // ),
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
        // SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width * 0.6,
        //   child: Stack(
        //     children: [
        //       Container(
        //         decoration: BoxDecoration(
        //             color: Colors.pinkAccent,
        //             image: DecorationImage(
        //                 fit: BoxFit.cover,
        //                 colorFilter: ColorFilter.mode(
        //                     Colors.black.withOpacity(0.2), BlendMode.dstATop),
        //                 image: const AssetImage(
        //                   'assets/images/everest.jpg',
        //                 ))),
        //         child: Container(),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 120),
        //         width: MediaQuery.of(context).size.width * 0.6,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "${formatDateForScheduleList(DateTime.now())} ",
        //               style: const TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 24,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //             Container(
        //               child: Text(
        //                 formatDateForImage(DateTime.now()),
        //                 textAlign: TextAlign.center,
        //                 style: const TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 21,
        //                 ),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 160),
        //         width: MediaQuery.of(context).size.width * 0.6,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "${isBusy(_meetings!.first.availabilityView!) ? 'MEŞGUL' : 'MÜSAİT'} ",
        //               style: const TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 32,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 250),
        //         width: MediaQuery.of(context).size.width * 0.6,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             CircleAvatar(
        //               maxRadius: 90,
        //               backgroundColor: mainColor,
        //               child: findFirstFreeTime(
        //                           _meetings!.first.availabilityView!) ==
        //                       null
        //                   ? const Icon(
        //                       Icons.add,
        //                       color: Colors.white,
        //                       // weight: 30,
        //                       size: 100,
        //                     )
        //                   : Text(
        //                       findFirstFreeTime(
        //                           _meetings!.first.availabilityView!)!,
        //                       style: const TextStyle(
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold,
        //                           fontSize: 35),
        //                     ),
        //             )
        //           ],
        //         ),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 490),
        //         width: MediaQuery.of(context).size.width * 0.6,
        //         child: const Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               "Toplantı Oluştur",
        //               style: TextStyle(
        //                   color: Colors.white,
        //                   fontWeight: FontWeight.bold,
        //                   fontSize: 35),
        //             ),
        //           ],
        //         ),
        //       ),
        //       Container(
        //         margin: const EdgeInsets.only(top: 550),
        //         width: MediaQuery.of(context).size.width * 0.6,
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Text(
        //               widget.roomName,
        //               style: const TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 35,
        //                   fontFamily: AutofillHints.addressCity),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        Container(
          color: mainColor,
          width: MediaQuery.of(context).size.width * 0.6,
          child: TableCalendar<ScheduleItem>(
            // rowHeight: 40,
            locale: "tr_TR",
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            firstDay: DateTime.now().add(const Duration(days: -7)),
            lastDay: DateTime.now().add(const Duration(days: 7)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 17)),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white),
              selectedDecoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              todayDecoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
              markerDecoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),

              markersMaxCount: 1,
              weekNumberTextStyle: TextStyle(color: Colors.white),

              // holidayTextStyle: TextStyle(color: Colors.grey),
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
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
                          contentPadding: EdgeInsets.all(0),
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
                                formatDateForImage(_selectedDay!),
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
                              const SizedBox(
                                height: 10,
                              )
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
