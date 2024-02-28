// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// import 'package:http/http.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/helpers/utils.dart';
import 'package:meet_app/models/request/create_calendar_request.dart';
import 'package:meet_app/models/response/get_calendars_response.dart';
// import 'package:meet_app/pages/calendar/add_calendar_page.dart';
import 'package:meet_app/pages/event/event_list_page.dart';
import 'package:meet_app/services/calendar_service.dart';
import 'package:meet_app/widgets/app_bar.dart';

class CalendarListPage extends StatefulWidget {
  const CalendarListPage({super.key});

  @override
  State<CalendarListPage> createState() => _CalendarListPageState();
}

class _CalendarListPageState extends State<CalendarListPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _calendarController = TextEditingController();
  List<Calendar>? _calendarList;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _calendarList = await CalendarService().get();
      setState(() {});
    } catch (e) {
      buildRequestFailedAlert(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        var result = await CalendarService().create(
            CreateCalendarRequest(name: _calendarController.text.trim()));
        if (result) {
          getData();
          Navigator.pop(context);
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

  _createCalendarDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Takvim Oluştur'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Takvim adı giriniz";
                } else {
                  return null;
                }
              },
              controller: _calendarController,
              decoration: const InputDecoration(hintText: "Takvim Adı"),
            ),
          ),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(mainColor)),
                onPressed: () async => await _submitForm(),
                child:
                    const Text("Kaydet", style: TextStyle(color: Colors.white)))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: beymenAppbar('Takvimler', () => _createCalendarDialog()),
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
    return _calendarList != null && _calendarList!.isNotEmpty
        ? ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            // controller: _scrollController,
            itemCount: _calendarList?.length,
            itemBuilder: (context, index) {
              final calendar = _calendarList![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventListPage(
                                calendarId: calendar.id!,
                              )));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      color: mainColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Container(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Text(
                                  calendar.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  overflow: TextOverflow.clip,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                    )
                  ],
                ),
              );
            },
          )
        : const Center(
            child: Text("Calendars could not be found"),
          );
  }
}
