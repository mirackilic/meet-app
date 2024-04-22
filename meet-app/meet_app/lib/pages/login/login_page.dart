// import 'package:flutter/material.dart';
// import 'package:meet_app/constans.dart';
// import 'package:meet_app/helpers/utils.dart';
// import 'package:meet_app/pages/calendar/calendar_list_page.dart';
// import 'package:meet_app/services/user_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // automaticallyImplyLeading: showBackButton,
//         backgroundColor: mainColor,
//         centerTitle: true,
//         title: const Text(
//           "BEYMEN",
//           style: TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Container(
//               //   width: 500,
//               //   padding:
//               //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               //   child: TextFormField(
//               //     controller: emailController,
//               //     decoration: const InputDecoration(
//               //         border: OutlineInputBorder(), labelText: "Email"),
//               //     validator: (value) {
//               //       if (value == null || value.isEmpty) {
//               //         return 'Please enter your email';
//               //       }
//               //       return null;
//               //     },
//               //   ),
//               // ),
//               // Container(
//               //   width: 500,
//               //   padding:
//               //       const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//               //   child: TextFormField(
//               //     controller: passwordController,
//               //     obscureText: true,
//               //     decoration: const InputDecoration(
//               //         border: OutlineInputBorder(), labelText: "Password"),
//               //     validator: (value) {
//               //       if (value == null || value.isEmpty) {
//               //         return 'Please enter your password';
//               //       }
//               //       return null;
//               //     },
//               //   ),
//               // ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
//                 child: Center(
//                     child: ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStatePropertyAll(mainColor)),
//                         onPressed: () async {
//                           // if (_formKey.currentState!.validate()) {
//                             var result = await UserService().login();

//                             if (result) {
//                               // ignore: use_build_context_synchronously
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) =>
//                                           const CalendarListPage()));
//                             }
//                           // } else {
//                           //   buildRequestFailedAlert(context);
//                           // }
//                         },
//                         child: const Text("Giriş",
//                             style:
//                                 TextStyle(color: Colors.white, fontSize: 21)))
//                     //  ElevatedButton(
//                     //   onPressed: () {
//                     //     if (_formKey.currentState!.validate()) {
//                     //       // Navigate the user to the Home page
//                     //     } else {
//                     //       ScaffoldMessenger.of(context).showSnackBar(
//                     //         const SnackBar(content: Text('Please fill input')),
//                     //       );
//                     //     }
//                     //   },
//                     //   child: const Text('Submit'),
//                     // ),
//                     ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
