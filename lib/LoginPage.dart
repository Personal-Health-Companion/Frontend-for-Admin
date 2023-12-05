import 'package:admin/MainPage.dart';
import 'package:flutter/material.dart';
import 'Admin.dart';
import 'AdminDetails.dart';
import 'LoginAPI.dart';
import 'package:provider/provider.dart';
import 'MainPage.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '관리자 로그인',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF101522),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 0.08,
            ),
          ),
        ),
      ),
      body: LoginPanel(),
    );
  }
}

class LoginPanel extends StatefulWidget {
  LoginPanel({Key? key}) : super(key: key);

  @override
  State<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends State<LoginPanel> {
  TextEditingController IDController = TextEditingController();

  TextEditingController PWController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18.0),
      child: ListView(
        children: [
          SizedBox(height: 40,),
          Container(
              child: Image(image: AssetImage('assets/images/mainLogo_white1.png'))
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("관리자만 로그인할 수 있습니다.", style: TextStyle(color: Colors.red),)
            ],
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: IDController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF9F9FB),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(24),
                ),
                prefixIcon: const Icon(Icons.account_circle_outlined),
                labelText: "ID"
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: PWController,
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFF9F9FB),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(24),
                ),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                labelText: "Password"
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                var userID = IDController.text;
                var userPW = PWController.text;
                User loginUser = User(userID: userID, userPassword: userPW, userName: '', location: '');
                try {
                  bool LoggedIn = await userAPI.login(loginUser);

                  if(LoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) => MainPage()),
                    );
                  }

                } catch (e) {
                  print("ERROR: " + e.toString());
                  showModalBottomSheet<void>(context: context, builder: (context) => Error());
                }
              },
              child: const Text('입장하기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(100, 30, 100, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("로그인에 실패했습니다.", style: TextStyle(color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
