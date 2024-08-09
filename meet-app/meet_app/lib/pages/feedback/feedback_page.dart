import 'package:flutter/material.dart';
import 'package:meet_app/models/request/send_feedback_request.dart';
import 'package:meet_app/services/event_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  SendFeedbackRequest request =
      SendFeedbackRequest(rate: 0, featureName: "meetApp");
  bool _isLoading = false;

  Future<void> _sendFeedback() async {
    try {
      var result = await EventService().sendFeedback(request);
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Geri Bildiriminiz İçin Teşekkürler")));

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Başarısız. Bir sorun oluştu.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Başarısız. Bir sorun oluştu.")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        :
        // : Scaffold(
        // appBar: AppBar(
        //   centerTitle: true,
        //   leading: BackButton(onPressed: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => EventListPage()));
        //   }),
        //   // automaticallyImplyLeading: showBackButton,
        //   backgroundColor: const Color.fromARGB(255, 36, 44, 60),
        //   elevation: 4.0,
        //   title: const Text(
        //     "FEEDBACK",
        //     style: TextStyle(color: Colors.white),
        //   ),
        //   iconTheme: const IconThemeData(color: Colors.white),
        // ),
        // body:
        Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.4,
            // color: const Color(0xFFF8FAFB),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           "How's your experience?",
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: Color(0xFF0E141B),
                    //             fontSize: 23,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 8.0),
                          child: Text(
                            'Uygulamayı Değerlendirin',
                            style: TextStyle(
                              color: Color(0xFF0E141B),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 8.0,
                            children: List.generate(5, (index) {
                              return _buildRatingIcon(index + 1);
                            }),
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 16.0, vertical: 16.0),
                    //       child: Column(
                    //         children: [
                    //           SizedBox(
                    //             width: MediaQuery.of(context).size.width * 0.2,
                    //             child: ElevatedButton(
                    //               onPressed: () {},
                    //               style: ElevatedButton.styleFrom(
                    //                 backgroundColor: mainColor,
                    //                 minimumSize: Size(double.infinity, 48),
                    //                 shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(16.0),
                    //                 ),
                    //               ),
                    //               child: const Text(
                    //                 'Submit',
                    //                 style: TextStyle(
                    //                   color: Color(0xFFF8FAFB),
                    //                   fontSize: 14,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Text(
                                'Önerilerinizi mail yolu ile iletebilirsiniz',
                                style: TextStyle(
                                  color: Color(0xFF0E141B),
                                  fontSize: 21,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Text(
                                'meetingapp@beymen.com',
                                style: TextStyle(
                                  color: Color(0xFF4F7396),
                                  fontSize: 19,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // )
          );
  }

  Widget _buildRatingIcon(int rating) {
    Widget icon;
    switch (rating) {
      case 1:
        icon = IconButton(
            onPressed: () {
              request.rate = 1;
              _sendFeedback();
            },
            icon: const Icon(Icons.sentiment_very_dissatisfied,
                color: Color(0xFF4F7396), size: 50));
        break;
      case 2:
        icon = IconButton(
            onPressed: () {
              request.rate = 2;
              _sendFeedback();
            },
            icon: const Icon(Icons.sentiment_dissatisfied,
                color: Color(0xFF4F7396), size: 50));
        break;
      case 3:
        icon = IconButton(
            onPressed: () {
              request.rate = 3;
              _sendFeedback();
            },
            icon: const Icon(Icons.sentiment_neutral,
                color: Color(0xFF4F7396), size: 50));
        break;
      case 4:
        icon = IconButton(
            onPressed: () {
              request.rate = 4;
              _sendFeedback();
            },
            icon: const Icon(Icons.sentiment_satisfied,
                color: Color(0xFF4F7396), size: 50));
        break;
      case 5:
        icon = IconButton(
            onPressed: () {
              request.rate = 5;
              _sendFeedback();
            },
            icon: const Icon(Icons.sentiment_very_satisfied,
                color: Color(0xFF4F7396), size: 50));
        break;
      default:
        icon = IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sentiment_very_satisfied,
                color: Color(0xFF4F7396), size: 50));
    }

    return Column(
      children: [
        icon,
        const SizedBox(height: 5),
        Text(
          '$rating',
          style: const TextStyle(
            color: Color(0xFF4F7396),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
