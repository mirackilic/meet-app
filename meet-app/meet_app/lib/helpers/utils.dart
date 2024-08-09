import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meet_app/models/response/get_meetings_by_room.dart';

String formatDate(DateTime date) {
  var formatter = DateFormat('d MMMM HH:mm', 'tr');
  return formatter.format(date);
}

String formatDateForScheduleList(DateTime date) {
  date = date.add(const Duration(hours: 6));
  var formatter = DateFormat('HH:mm', 'tr');
  return formatter.format(date);
}

String formatMainHour(DateTime date) {
  var formatter = DateFormat('HH:mm', 'tr');
  return formatter.format(date);
}

String formatDateForCreateMeet(DateTime date) {
  var formatter = DateFormat('d MMMM yyyy', 'tr');
  return formatter.format(date);
}

String formatDateForImage(DateTime date) {
  DateFormat dateFormat = DateFormat("dd MMMM EEEE", "tr_TR");
  return dateFormat.format(date);
}

String formatDateForCalendar(DateTime date) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(date);
}

void buildRequestFailedAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('HATA'),
        content: const Text("Request failed"),
        actions: [
          ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 0, 101, 255))),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("TAMAM", style: TextStyle(color: Colors.white)))
        ],
      );
    },
  );
}

bool isBusy(String data) {
  // Mevcut saat bilgisini al
  DateTime now = DateTime.now();

  // Zamanın 8:00'dan sonra ve 17:00'dan önce olduğunu kontrol et
  if (now.hour >= 5 && now.hour < 12) {
    // Saat dilimini 30 dakika aralıklarla kontrol et
    int index = (now.hour - 8) * 2 + now.minute ~/ 30;

    // Verilen dizideki belirtilen saat dilimini kontrol et
    return data[index] == '2'; // '2' meşgul, '0' boş
  } else {
    // Çalışma saatleri dışında olduğunda varsayılan olarak meşgul kabul et
    return false;
  }
}

// String? findFirstFreeTime(String data) {
//   // return null;
//   // Başlangıç saati
//   int startHour = 5; // 08:00'den başlıyoruz
//   int startMinute = 12;

//   // Mevcut zamanı al
//   DateTime now = DateTime.now();

//   // Mevcut saat dilimini hesapla
//   int currentHour = now.hour - 3;
//   int currentMinute = now.minute;

//   // Mevcut saat dilimini indeks olarak hesapla
//   int currentIndex = (currentHour - startHour) * 2 + currentMinute ~/ 30;

//   // Mevcut zamanın sonraki boş saat dilimini bul
//   int freeIndex = currentIndex; // Başlangıçta mevcut zamanı başlangıç olarak al

//   while (freeIndex < data.length && data[freeIndex] != '0') {
//     freeIndex++; // Boş saat dilimi bulunana kadar arttır
//   }

//   if (freeIndex < data.length) {
//     // Boş saat dilimini bulduysak, onun başlangıç ve bitiş saatini oluştur
//     int freeHour = startHour + freeIndex ~/ 2;
//     int freeMinute = (freeIndex % 2) * 30;

//     // Saat dilimini oluştur ve ISO 8601 formatına dönüştür
//     DateTime freeTime =
//         DateTime(now.year, now.month, now.day, freeHour, freeMinute);

//     // Formatlanmış saat dilimini döndür
//     return formatDateForScheduleList(freeTime);
//   } else {
//     // Boş saat dilimi bulunamadıysa null döndür
//     return null;
//   }
// }

// Şu anki zaman aralığında olan toplantıyı bulan metot
Meeting? findCurrentMeeting(ValueNotifier<List<Meeting>> meetings) {
  DateTime now = DateTime.now();

  for (Meeting meeting in meetings.value) {
    DateTime start = DateTime.parse(meeting.start!.dateTime!
        .add(const Duration(hours: 3))
        .toString()); // UTC saatini yerel saate çevir
    DateTime end = DateTime.parse(meeting.end!.dateTime!
        .add(const Duration(hours: 3))
        .toString()); // UTC saatini yerel saate çevir

    if (now.isAfter(start) && now.isBefore(end)) {
      return meeting;
    }
  }
  return null;
}

Meeting? findNextMeeting(ValueNotifier<List<Meeting>> scheduleItems) {
  DateTime now = DateTime.now();

  for (Meeting item in scheduleItems.value) {
    DateTime start = DateTime.parse(item.start!.dateTime!
        .add(const Duration(hours: 3))
        .toString()); // UTC saatini yerel saate çevir
    // Toplantı başlangıç zamanı şu andan sonra olan ilk toplantıyı bul
    if (start!.isAfter(now)) {
      return item;
    }
  }
  return null;
}
