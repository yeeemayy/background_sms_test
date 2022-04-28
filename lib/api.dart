import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Api {
  showServerErrorMsg(data) async {
    print(data);
  }

  Future storeSMS(String sms) async {
    Map<String, String> tempHeaders = {
      "Content-Type": "application/json",
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjk3OGYwOTNmYTczMWJmYzEwYWIwNmIyOGE5NjU3MTE1MzAyMzAxNGNmMTlmMjA3NTBmZjg4YTI4NmRjZjU5NDk2NDRjODE3NjZiODYxOTYiLCJpYXQiOjE2NTExMTg5MDgsIm5iZiI6MTY1MTExODkwOCwiZXhwIjoxNjgyNjU0OTA4LCJzdWIiOiIzIiwic2NvcGVzIjpbXX0.tPHu8jWOSRvuKBtAacUBetc-muQWKNRbnbfz5AR403y4YwGT5AH0WMcL8TeJ3XUj5z2ifBPPwk3hNn-sGD7VLqCi7GKo3_KweFnw5AQzp9GCm1focBBH3G-4opZnXNqZQBMLIQW6Fo7x1502Jn4Fy_r09EgSTEEaRF8r2GNBeXPDP2r2UafithMHsy3vQtlv3EKvJkKji-i-netWUzXSAwx6-dY1z05Gudh2LWRMZGmKGfUjElO4_4eZPmIPvoYhbmSOAhb-yZAbraKX85jyM--GV-PTU_M8v8PWOCxp6oq2ZwXrGzKbGchWbLSsqCwpE0SXnABTRu1wh_7IvWjKBuaaU9rYoUZP_01uliUvGAXqBuwdoRF1zIgGx15Cb2dmkWgv5-l351rkD4HUKF4vrYI6MfWCHTNNwXByS9CowNpBwGC1IF2I1M7LyoPpIHiDHWTFpgb9Tk5b3kIAF3Zig2xrxXRxAyRkUVnSvhOPPImqWWtOiYHjuoGTnctE7LkoNhkt01PgPp18aqdnIm9CBBKaYIJJwYgyfcbdIGtY3iX26QDMHZzWR2uvkwlcDhLPmZNn4sfPhqryt-ztHsqtmEDEIDBpEHV7KcTxEUmTv3p-bEFKslcyliuLuXDHDU4tlgWbAmPo99f2XoVAFLWWYauOUCP5-cTxR5ZRsAIuOS4"
    };
    String storeContactsUrl = "https://staging3.techflow.app/api/user/sms-logs";
    print('Store sms: POST $storeContactsUrl\nParams: $sms');

    var response = await http.post(Uri.parse(storeContactsUrl),
        headers: tempHeaders, body: sms);

    log(response.body);

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      switch (response.statusCode) {
        case 500:
          showServerErrorMsg('Server error, Please try again later');
          break;
        default:
          showServerErrorMsg(data);
          return response.statusCode;
          break;
      }
    }
  }
}
