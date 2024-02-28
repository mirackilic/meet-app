import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meet_app/constans.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants.dart';

class RequestHelper {
  static Future<http.Response> sendRequest(String type, String url,
      {Map<String, dynamic>? body}) async {
    // final prefs = await SharedPreferences.getInstance();
    final token =
        "eyJ0eXAiOiJKV1QiLCJub25jZSI6IjZfeTFVaVdVbEkxVzJRZWFoZXhhODVfR19heWVvcWR3bE4tcTVKeEZsQmsiLCJhbGciOiJSUzI1NiIsIng1dCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSIsImtpZCI6IlhSdmtvOFA3QTNVYVdTblU3Yk05blQwTWpoQSJ9.eyJhdWQiOiIwMDAwMDAwMy0wMDAwLTAwMDAtYzAwMC0wMDAwMDAwMDAwMDAiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC84OWQ4MzQzMS1jMTg3LTRlNzgtOTE0Ni00ZjBiYzJkZjg4MmQvIiwiaWF0IjoxNzA5MTQwMTM5LCJuYmYiOjE3MDkxNDAxMzksImV4cCI6MTcwOTIyNjgzOSwiYWNjdCI6MCwiYWNyIjoiMSIsImFpbyI6IkFWUUFxLzhXQUFBQUFMbUdPZ2I2c2ltdmdHL1UxT2VUZm5naW8yV1UrYjFsRFVjT08rTzB4YjJJQ2ZsSkVjVmxPVUJ2eGk2U2RWQXZTYllpSGhld1J0K3JEcUdralg1VVdIV0tNeWxvYU5nY2NTVlFYb2M2M1FjPSIsImFtciI6WyJwd2QiLCJtZmEiXSwiYXBwX2Rpc3BsYXluYW1lIjoiR3JhcGggRXhwbG9yZXIiLCJhcHBpZCI6ImRlOGJjOGI1LWQ5ZjktNDhiMS1hOGFkLWI3NDhkYTcyNTA2NCIsImFwcGlkYWNyIjoiMCIsImZhbWlseV9uYW1lIjoiS0lMSUMiLCJnaXZlbl9uYW1lIjoiTWlyYWMiLCJpZHR5cCI6InVzZXIiLCJpcGFkZHIiOiIzLjcwLjMyLjExOSIsIm5hbWUiOiJNaXJhYyBLSUxJQyIsIm9pZCI6IjQ1YjQxOWQ0LWViMTQtNGU4NS1iZTQ5LTAyYjEwOTQ0YTNlMSIsIm9ucHJlbV9zaWQiOiJTLTEtNS0yMS0yNzM4NTIzMDQyLTI0MTM1OTcyOTMtMjczMTc0NTgwMi0zODk3MSIsInBsYXRmIjoiMyIsInB1aWQiOiIxMDAzMjAwMjY4OTEyNzdCIiwicmgiOiIwLkFSOEFNVFRZaVlmQmVFNlJSazhMd3QtSUxRTUFBQUFBQUFBQXdBQUFBQUFBQUFDRkFOTS4iLCJzY3AiOiJDYWxlbmRhcnMuUmVhZEJhc2ljIENhbGVuZGFycy5SZWFkV3JpdGUgb3BlbmlkIHByb2ZpbGUgVGFza3MuUmVhZCBVc2VyLlJlYWQgZW1haWwiLCJzaWduaW5fc3RhdGUiOlsia21zaSJdLCJzdWIiOiJOOXlZbldydC1WREljWXlDVDQwQnlDNUVZWHdsdkxQT2pZMmM2MFhNbW9VIiwidGVuYW50X3JlZ2lvbl9zY29wZSI6IkVVIiwidGlkIjoiODlkODM0MzEtYzE4Ny00ZTc4LTkxNDYtNGYwYmMyZGY4ODJkIiwidW5pcXVlX25hbWUiOiJtaXJhYy5raWxpY0BiZXltZW4uY29tIiwidXBuIjoibWlyYWMua2lsaWNAYmV5bWVuLmNvbSIsInV0aSI6IkNCb241RjhVSjAyeHFhdzZMSmdjQUEiLCJ2ZXIiOiIxLjAiLCJ3aWRzIjpbImI3OWZiZjRkLTNlZjktNDY4OS04MTQzLTc2YjE5NGU4NTUwOSJdLCJ4bXNfY2MiOlsiQ1AxIl0sInhtc19zc20iOiIxIiwieG1zX3N0Ijp7InN1YiI6ImhWTmJtSnBhU05aTTgyOUpwSWZpM21HQ1hJal9GS2dvQ29PT3lpaXMwQ1EifSwieG1zX3RjZHQiOjEzOTgyODE0MDl9.d-b4F9SNLn1qLF_b0g1UMI1TNdBRz2vPWE52oR_rLSk9G0IfNq22zMYGx1X3cx1-Tj9oXGo_dz8hn2lefVeRX38AZPR2Y6G6oCTi6zRQiM0JfyvGKHeFyoeAuFncNzXdFiVv0zkkmse7h-Oc7PyVFxTx0xi0Mkant8xVwFtJqSV0Y0V2pSB8SafW7ZfwkE_LRMG28KRU45krbrAmFbKpr-ahqe3Em1XW50D9d_wSApLKQLWhg_1x3AHSy6s4L6ZaKg_NO0wBVJheZdhqGZhJHkNK6VYRqGtRpQyHcTlZgTdySXy89l-aHafTadDAi_bSVW6sU7iNo75WN2btbx6DYg";
    //prefs.getString('token');

    var headers = {'Authorization': 'Bearer $token'};

    headers.addAll({'Content-Type': 'application/json'});

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

    // final responseBody = json.decode(response.body);
  }
}
