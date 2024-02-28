// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/response/get_events_response.dart';
import 'package:meet_app/pages/event/add_event_page.dart';
import 'package:meet_app/services/event_service.dart';
import 'package:meet_app/widgets/app_bar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

class EventListPage extends StatefulWidget {
  final String calendarId;
  const EventListPage({super.key, required this.calendarId});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  bool _isLoading = false;
  ValueNotifier<List<Event>>? _selectedEvents;
  // Map<DateTime, List<Event>>? _allEvents = {};
  List<Event>? _weeklyEvents;

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

  List<Event> _getEventsForDay(DateTime day) {
    if (_weeklyEvents == null || _weeklyEvents!.isEmpty) return [];
    return _weeklyEvents!
        .where((element) =>
            element.start!.dateTime!.month == day.month &&
            element.start!.dateTime!.day == day.day)
        .toList();
  }

  _getAllEvents(DateTime day) async {
    // Bugünden 7 gün önce ve sonrasını hesapla
    DateTime sevenDaysAgo = _selectedDay!.subtract(const Duration(days: 7));
    DateTime sevenDaysAfter = _selectedDay!.add(const Duration(days: 7));

    String formattedSevenDaysAgo = formatDateForCalendar(sevenDaysAgo);
    String formattedSevenDaysAfter = formatDateForCalendar(sevenDaysAfter);

    try {
      setState(() {
        _isLoading = true;
      });
      _weeklyEvents = await EventService().getByCalendarId(
          widget.calendarId, formattedSevenDaysAgo, formattedSevenDaysAfter);
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

  Future<void> _launchInBrowser(String url) async {
    var uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: beymenAppbar(
          'Toplantı',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEventPage(
                        selectedDate: _selectedDay!,
                        calendarId: widget.calendarId,
                      )))),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: beymenGold,
              ),
            )
          : _buildBody(),
    );
  }

  Container _buildBody() {
    return Container(
      color: mainColor,
      child: Column(
        children: [
          TableCalendar<Event>(
            rowHeight: 40,
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
          const SizedBox(height: 15),
          _selectedEvents == null
              ? Container()
              : Expanded(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents!,
                    builder: (context, value, _) {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 4.0,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(5),
                              onTap: () async =>
                                  value[index].onlineMeeting == null
                                      ? null
                                      : await _launchInBrowser(
                                          value[index].onlineMeeting!.joinUrl!),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: beymenGold,
                                child: Icon(
                                  Icons.calendar_month_rounded,
                                  color: mainColor,
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                '${value[index].subject}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          formatDate(
                                              value[index].start!.dateTime!),
                                          style: const TextStyle(
                                              color: Colors.grey)),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person_2_outlined,
                                            color: Colors.grey,
                                            size: 17,
                                          ),
                                          Text(
                                              ' ${value[index].organizer!.emailAddress!.name}',
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
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
    );
  }
}
