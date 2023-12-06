import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'LoginAPI.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '권한 요청',
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
      body: MainPanel(),
    );
  }
}

class MainPanel extends StatefulWidget {
  const MainPanel({Key? key}) : super(key: key);

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: FutureBuilder(
        future: firebase_storage.FirebaseStorage.instance
            .ref('secure')
            .listAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final result = snapshot.data as firebase_storage.ListResult;
            final files = result.items;

            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];

                return FutureBuilder(
                  future: file.getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final url = snapshot.data as String;

                      return Padding(
                        padding: EdgeInsets.only(left: 14.0, right: 14.0),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                bool isChanged = await userAPI.changeRole(int.parse(file.name));

                                if(isChanged) {
                                  showModalBottomSheet<void>(context: context, builder: (context) => Success());
                                }
                              },
                              child: Icon(Icons.check, color: Colors.green,),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewScreen(url),
                                    ),
                                  );
                                },
                                child: Text("[ ID: ${file.name} ] 님의 인증 서류 보기"),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Success extends StatelessWidget {
  Success({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(100, 30, 100, 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("사용자의 권한이 변경되었습니다.", style: TextStyle(color: Colors.red),),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      )
    );
  }
}