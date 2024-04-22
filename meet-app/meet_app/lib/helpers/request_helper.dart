import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meet_app/constans.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants.dart';

class RequestHelper {
  static Future<http.Response> sendRequest(String type, String url,
      {Map<String, dynamic>? body}) async {
    // final prefs = await SharedPreferences.getInstance();
    // final token =
    //     "eyJ0eXAiOiJKV1QiLCJub25jZSI6IkdTazFlMUd3a09zMXNJbVdMdzlhRE9xcHg5QUc1Rm9idERaSkN6dFU2RjAiLCJhbGciOiJSUzI1NiIsIng1dCI6InEtMjNmYWxldlpoaEQzaG05Q1Fia1A1TVF5VSIsImtpZCI6InEtMjNmYWxldlpoaEQzaG05Q1Fia1A1TVF5VSJ9.eyJhdWQiOiJodHRwczovL2dyYXBoLm1pY3Jvc29mdC5jb20iLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC84OWQ4MzQzMS1jMTg3LTRlNzgtOTE0Ni00ZjBiYzJkZjg4MmQvIiwiaWF0IjoxNzEzNzMzMDM0LCJuYmYiOjE3MTM3MzMwMzQsImV4cCI6MTcxMzczNjkzNCwiYWlvIjoiRTJOZ1lPRHRLU29RWGY1NjRRbmh6WjRueTM0K0FRQT0iLCJhcHBfZGlzcGxheW5hbWUiOiJNZWV0aW5nX0FwcCIsImFwcGlkIjoiMTY0MmMxOWMtYWQ4Ni00Nzk0LWJlZjgtMzUzOTdiNmU3MDQ4IiwiYXBwaWRhY3IiOiIxIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvODlkODM0MzEtYzE4Ny00ZTc4LTkxNDYtNGYwYmMyZGY4ODJkLyIsImlkdHlwIjoiYXBwIiwib2lkIjoiOGFhNTM1ODUtMDBkNy00MTk5LTk2MGUtYmEzZGUzMTQ2MzFkIiwicmgiOiIwLkFSOEFNVFRZaVlmQmVFNlJSazhMd3QtSUxRTUFBQUFBQUFBQXdBQUFBQUFBQUFDRkFBQS4iLCJyb2xlcyI6WyJDYWxlbmRhcnMuUmVhZCIsIkNhbGVuZGFycy5SZWFkQmFzaWMuQWxsIl0sInN1YiI6IjhhYTUzNTg1LTAwZDctNDE5OS05NjBlLWJhM2RlMzE0NjMxZCIsInRlbmFudF9yZWdpb25fc2NvcGUiOiJFVSIsInRpZCI6Ijg5ZDgzNDMxLWMxODctNGU3OC05MTQ2LTRmMGJjMmRmODgyZCIsInV0aSI6Ijd1Y19SNVA3V0UyLUN6V0huTFpLQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbIjA5OTdhMWQwLTBkMWQtNGFjYi1iNDA4LWQ1Y2E3MzEyMWU5MCJdLCJ4bXNfdGNkdCI6MTM5ODI4MTQwOX0.SBtwC_1HrwbzDDP3qNlbvaZuDBBnlTBjGM4mSxqec7XB-HtmJYd_v2-mdYPm0s9oVWnd2LV-4OH1zTKiJvei0SZ7pWVi-TfpbZw3vwvJ9dSQ63UwFd5YM8wqvAUwsghoWtuOZ2Jq3bf8npnlUByZqh_omxAXujnWQFJEgoaGc7Gdz3tuniUIzyVtzXS7RGjm1_HiX_LyMt4OjQTBe2y9v0QuE1YBC5YQI0lRREaeQ1nP1IUDUVnHwQAQzChxapz7bVtbjctgeGAN0YhPbk6E4mgs_FO9Qc5qYssv-cJtxKt0vKxIZktXVdPTl6vFPLzRt7DFGq2boPwXdk6xpHL7vw"; //prefs.getString('token');
    // var headers = {'Authorization': 'Bearer $token'};

    var headers = {'Content-Type': 'application/json'};
    headers.addAll({'x-tenantCode': 'beymen'});

    String baseUrl = apiUrl;

    String requestUrl = baseUrl + url;
    switch (type.toLowerCase()) {
      case 'get':
        return await http.get(Uri.parse(requestUrl), headers: headers);
      case 'post':
        return await http.post(Uri.parse(requestUrl),
            headers: headers, body: jsonEncode(body));
      case 'put':
        return await http.put(Uri.parse(requestUrl),
            headers: headers, body: jsonEncode(body));
      default:
        throw Exception('Invalid request type: $type');
    }
  }
}
