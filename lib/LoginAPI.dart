import 'dart:convert';
import 'Admin.dart';
import 'package:http/http.dart' as http;

class userAPI {

  static const String baseUrl = 'http://3.39.13.133:8080';

  // 로그인
  static Future<bool> login(User user) async {
    final url = Uri.parse('$baseUrl/admin');
    final body = {
      "id": user.Id,
      "userID": user.userID,
      "userPassword": user.userPassword,
      "userName": user.userName,
      "location": user.location,
      "details": user.details
    };

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));

    print('LOGIN Response status: ${response.statusCode}'); // 응답 상태 코드 로그 출력
    print('LOGIN Response body: ${response.body}'); // 응답 본문 로그 출력

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // 권한 변경
  static Future<bool> changeRole(int Id) async {
    final url = Uri.parse('$baseUrl/user/role/$Id');
    final response = await http.put(url);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

}