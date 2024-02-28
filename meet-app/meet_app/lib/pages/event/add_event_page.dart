// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/request/create_meet_request.dart';
import 'package:meet_app/pages/calendar/calendar_list_page.dart';
import 'package:meet_app/pages/event/event_list_page.dart';
import 'package:meet_app/services/event_service.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;
  final String calendarId;
  const AddEventPage(
      {super.key, required this.selectedDate, required this.calendarId});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  bool _isLoading = false;
  late TimeOfDay _starttime;
  late TimeOfDay _endtime;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStartTime) {
        _starttime = picked;
      } else {
        _endtime = picked;
      }
    }
    setState(() {});
  }

  Future _createMeet() async {
    if (_starttime.hour < _endtime.hour) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(widget.selectedDate);

        var startHours = _starttime.hour - 3;
        var endHours = _endtime.hour - 3;

        String startMin = _starttime.minute < 10
            ? '0${_starttime.minute}'
            : '${_starttime.minute}';
        String endMin =
            _endtime.minute < 10 ? '0${_endtime.minute}' : '${_endtime.minute}';

        String startHour = startHours < 10 ? '0$startHours' : '$startHours';
        String endHour = endHours < 10 ? '0$endHours' : '$endHours';

        String formattedStartTime = '$startHour:$startMin';
        String formattedEndTime = '$endHour:$endMin';

        String combinedStartTime =
            '$formattedDate' 'T' '$formattedStartTime:00.000Z';
        String combinedEndTime =
            '$formattedDate' 'T' '$formattedEndTime:00.000Z';

        var request = CreateMeetRequest(
            subject: _subjectController.text.trim(),
            start: MeetTime(dateTime: combinedStartTime, timeZone: 'UTC'),
            end: MeetTime(dateTime: combinedEndTime, timeZone: 'UTC'));

        var result = await EventService().create(request, widget.calendarId);
        if (result) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CalendarListPage()));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventListPage(
                        calendarId: widget.calendarId,
                      )));
        } else {
          buildRequestFailedAlert(context);
        }
      } catch (e) {
        buildRequestFailedAlert(context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _starttime = TimeOfDay.now();
    _endtime = TimeOfDay.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          centerTitle: true,
          elevation: 4.0,
          title: const Text(
            'Toplantı Oluştur',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: beymenGold,
                ),
              )
            : _buildBody(context));
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                formatDateForCreateMeet(widget.selectedDate),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: _subjectController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Lütfen bir konu giriniz";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          fillColor: Colors.white,
                          hintText: "Konu",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Icon(
                  //   Icons.watch_later_outlined,
                  //   color: Colors.white,
                  // ),
                  const Text(
                    'Başlangıç Saati:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ' ${_starttime.hour}:${_starttime.minute}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 35,
                        width: 95,
                        child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white)),
                            onPressed: () {
                              _selectTime(context, true);
                            },
                            child: const Text("Düzenle",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: const Color.fromARGB(
                                        255, 56, 68, 76)))),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // const Icon(
                  //   Icons.watch_later_outlined,
                  //   color: Colors.white,
                  // ),
                  const Text(
                    'Bitiş Saati:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ' ${_endtime.hour}:${_endtime.minute}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                          height: 35,
                          width: 95,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.white)),
                            onPressed: () {
                              _selectTime(context, false);
                            },
                            child: Text("Düzenle",
                                style:
                                    TextStyle(fontSize: 12, color: mainColor)),
                          ))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.white)),
                        onPressed: () async => await _createMeet(),
                        child:
                            Text("Kaydet", style: TextStyle(color: mainColor))),
                  )
                ],
              )
              // _buildtimepick("start", true, _starttime, (x) {
              //   setState(() {
              //     _starttime = x;
              //     print("the picked time is: $x");
              //   });
              // }),
              // const SizedBox(height: 10),
              // _buildtimepick("end", true, _endtime, (x) {
              //   setState(() {
              //     _endtime = x;
              //     print("the picked time is: $x");
              //   });
              // }),
            ],
          ),
        ),
      ),
    );
  }
}
