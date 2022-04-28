import 'dart:convert';
import 'dart:developer';

import 'package:background_sms_test/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Api api = Api();
    try {
      SmsQuery query = SmsQuery();
      await query
          .querySms(kinds: [SmsQueryKind.inbox], count: 10).then((value) async {
        List<Map> _messages = value
            .map((e) => {
                  "address": e.address,
                  "body": e.body,
                  "id": e.id,
                  "thread_id": e.threadId,
                  "read": e.isRead,
                  "date": e.date?.millisecondsSinceEpoch,
                  "dateSent": e.dateSent?.millisecondsSinceEpoch
                })
            .toList();

        print(_messages.toString());
        log('log' + jsonEncode(_messages));

        await api.storeSMS(jsonEncode(_messages)).then((value) {
          print('fuck sms' + value.toString());
          if (!(value is int)) {
            print('stored!');
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }

    // await api.storeSMS("""
    // [{"address":"Celcom","body":"PERCUMA RM2 kredit bila top-up RM10. Sah sehingga 27/04. Bonus diberi dalam masa 24 jam. Ikhlas, Celcom.","id":6678,"thread_id":224,"read":true,"date":1650686223967,"dateSent":1650686221000},{"address":"MKN","body":"RM0 Aidil Fitri bakal menjelang. Rayakan dengan selamat. Lindungi orang tersayang. Vaksin anak anda dan dapatkan dos penggalak bagi warga emas.","id":6677,"thread_id":222,"read":true,"date":1650621798041,"dateSent":1650621796000},{"address":"Celcom","body":"PERCUMA 500MB Internet bila top-up RM5. Sah sehingga 26/04. Bonus diberi dalam masa 24 jam. Ikhlas, Celcom.","id":6676,"thread_id":224,"read":true,"date":1650620401549,"dateSent":1650620398000},{"address":"Celcom","body":"RM0 Head over to the Esukan.gg eshop at bit.ly/CelcomEsukan to buy all your favourite game credits! For easy payment, make sure to pay using Celcom billing. Sincerely, Celcom.","id":6675,"thread_id":224,"read":true,"date":1650610645566,"dateSent":1650610640000},{"address":"Celcom","body":"PERCUMA 500MB Internet bila top-up RM5. Sah sehingga 25/04. Bonus diberi dalam masa 24 jam. Ikhlas, Celcom.","id":6674,"thread_id":224,"read":true,"date":1650526516243,"dateSent":1650526513000},{"address":"celcom","body":"RM0 Daftar utk Pelan Keluarga Celcom MEGA hari ini & dapatkan sehingga 6 talian keluarga dengan Internet TANPA HAD @ RM40/bln, jimat lebih byk dgn telefon BARU IPHONE 13 series! Kunjungi CELCOM PAVILION BUKIT JALIL di Lvl 5 atau hubungi 0194903008.Tertakluk T&S. Ikhlas, Celcom.","id":6673,"thread_id":214,"read":true,"date":1650079812970,"dateSent":1650079811000},{"address":"22262","body":"RM0 Tawaran Credit Advance anda telah tamat. Untuk dapatkan Credit Advance, hantar ADV1/ADV2/ADV5/ADV10 ke 22262. Untuk maklumat lanjut, hantar HELP ke 22262","id":6672,"thread_id":217,"read":true,"date":1649489468619,"dateSent":1649489465000},{"address":"2888","body":"Your account balance is getting low. Please recharge your account soon.\n     ","id":6671,"thread_id":220,"read":true,"date":1649421803592,"dateSent":1649421794000},{"address":"22262","body":"RM0 Kekurangan kredit? Dapatkan Credit Advance RM1. Untuk terima, sila balas YES dan RM0.75 akan dikreditkan ke akaun anda. Caj servis RM0.25 dikenakan. Untuk bantuan lanjut, hubungi Celcom di 1111","id":6670,"thread_id":217,"read":true,"date":1649402830932,"dateSent":1649402828000},{"address":"39881","body":"RM0 Your Google Play purchase via Celcom mobile account at RM19.90 is successful! Thank you & enjoy. Correlation ID:g310679743575188835216930870224379206281","id":6669,"thread_id":225,"read":true,"date":1649402160332,"dateSent":1649402157000}]
    // """).then((value) {
    //   print('fuck sms' + value.toString());
    //   if (!(value is int)) {
    //     print('stored!');
    //   }
    // });

    print(
        "Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery query = SmsQuery();
  List<SmsMessage> threads = [];

  @override
  void initState() {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );

    Workmanager().registerOneOffTask("1", "simpleTask");

// Periodic task registration
    Workmanager().registerPeriodicTask("2", "simplePeriodicTask",
        // When no frequency is provided the default 15 minutes is set.
        // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
        frequency: Duration(minutes: 15),
        initialDelay: Duration(seconds: 10));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (await Permission.sms.request().isGranted) {
        query.querySms(kinds: [SmsQueryKind.inbox], count: 10).then((value) {
          threads = value;
          setState(() {});
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Example"),
          ),
          body: ListView.builder(
            itemCount: threads.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    minVerticalPadding: 8,
                    minLeadingWidth: 4,
                    title: Text(threads[index].body ?? 'empty'),
                    subtitle: Text(threads[index].address ?? 'empty'),
                  ),
                  const Divider()
                ],
              );
            },
          ),
        ));
  }
}
