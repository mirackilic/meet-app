import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:meet_app/constans.dart';
import 'package:meet_app/models/response/get_meeting_rooms_response.dart';
import 'package:meet_app/pages/event/event_list_page.dart';
import 'package:meet_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomSelectPage extends StatefulWidget {
  const RoomSelectPage({super.key});

  @override
  RoomSelectPageState createState() => RoomSelectPageState();
}

class RoomSelectPageState extends State<RoomSelectPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final formkey = GlobalKey<FormState>();
  // LoginRequest request = LoginRequest();
  bool _isLoading = false;
  List<MeetingRooms>? meetingRooms;
  MeetingRooms? meetingRoom;

  Future<List<MeetingRooms>?> getMeetingRooms() async {
    setState(() {
      _isLoading = true;
    });
    meetingRooms = await UserService().getRooms();

    if (meetingRooms != null) {
      meetingRoom = meetingRooms![0];
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Hata oluştu!"),
              content: const Text(
                  "Toplantı odaları çekilirken bir sorun oluştu. Bağlantınızı kontrol ediniz."),
              actions: [
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 0, 101, 255))),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("TAMAM"))
              ],
            );
          });
    }
    setState(() {
      _isLoading = false;
    });
    return meetingRooms;
  }

  @override
  void initState() {
    getMeetingRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: mainColor,
        elevation: 4.0,
        title: const Text(
          "Toplantı Odası Seçim",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      key: _scaffoldkey,
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: beymenGold,
              ),
            )
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: <Widget>[
            Form(
                key: formkey,
                child: Column(
                  children: [
                    meetingRooms == null
                        ? Container()
                        : DropdownSearch<MeetingRooms>(
                            popupProps:
                                const PopupProps.menu(showSearchBox: true),
                            dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    labelText: "Toplantı Odası",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Color.fromARGB(
                                                255, 0, 101, 255))))),
                            selectedItem: meetingRoom,
                            itemAsString: (item) => "${item.name} ",
                            items: meetingRooms!.map((room) {
                              return MeetingRooms(
                                  id: room.id,
                                  name: room.name,
                                  mail: room.mail,
                                  graphId: room.graphId,
                                  storeCode: room.storeCode);
                            }).toList(),
                            onChanged: (selectedValue) async {
                              meetingRoom = selectedValue;
                            },
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(mainColor)),
                        onPressed: () async {
                          if (meetingRoom == null) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Eksik bilgi"),
                                    content:
                                        const Text("Oda seçimi yapmalısınız"),
                                    actions: [
                                      ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Color.fromARGB(
                                                          255, 0, 101, 255))),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("TAMAM"))
                                    ],
                                  );
                                });
                          }
                          final prefs = await SharedPreferences.getInstance();
                          // await prefs.setString(
                          //     'selectedRoom', meetingRoom!.toJson().toString());

                          final meetingRoomMap = meetingRoom!.toJson();
                          final meetingRoomJson = jsonEncode(meetingRoomMap);
                          await prefs.setString(
                              'selectedRoom', meetingRoomJson);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EventListPage()));
                        },
                        child: const Text(
                          'GİRİŞ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )),
            // Expanded(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.end,
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         SizedBox(
            //           width: MediaQuery.of(context).size.width,
            //           child: ElevatedButton(
            //             style: ButtonStyle(
            //                 backgroundColor:
            //                     MaterialStatePropertyAll(mainColor)),
            //             onPressed: () async {
            //               if (meetingRoom == null) {
            //                 showDialog(
            //                     context: context,
            //                     builder: (BuildContext context) {
            //                       return AlertDialog(
            //                         title: const Text("Eksik bilgi"),
            //                         content: const Text("Oda seçimi yapmalısınız"),
            //                         actions: [
            //                           ElevatedButton(
            //                               style: const ButtonStyle(
            //                                   backgroundColor:
            //                                       MaterialStatePropertyAll(
            //                                           Color.fromARGB(
            //                                               255, 0, 101, 255))),
            //                               onPressed: () =>
            //                                   Navigator.pop(context),
            //                               child: const Text("TAMAM"))
            //                         ],
            //                       );
            //                     });
            //               }
            //               final prefs = await SharedPreferences.getInstance();
            //               await prefs.setString(
            //                   'token', meetingRoom!.toJson().toString());
            //               // ignore: use_build_context_synchronously
            //               Navigator.pushReplacement(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (BuildContext context) =>
            //                           EventListPage()));
            //             },
            //             child: const Text(
            //               'GİRİŞ',
            //               style: TextStyle(
            //                   fontSize: 16,
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
