import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart'; // ✅ Toast 패키지 import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeechTestPage(),
    );
  }
}

class SpeechTestPage extends StatefulWidget {
  @override
  _SpeechTestPageState createState() => _SpeechTestPageState();
}

class _SpeechTestPageState extends State<SpeechTestPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "음성을 인식해볼게요.";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestMicPermission();
    });
  }

  Future<void> _requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('status: $status');

        if (status == "notListening" && _isListening) {
          Future.delayed(Duration(milliseconds: 500), () {
            _startListening();
          });
        }
      },
      onError: (error) {
        print('error: $error');
        if (_isListening) {
          Future.delayed(Duration(seconds: 1), () {
            _startListening();
          });
        }
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          String recognized = result.recognizedWords;
          setState(() {
            _text = recognized;
          });
          print("recognizedWords: $recognized");

          // ✅ 조건 검사
          if (recognized.trim() == "잠깐 잠깐 잠깐") {
            Fluttertoast.showToast(
              msg: "녹음이 시작됩니다!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        listenFor: Duration(minutes: 5),
        pauseFor: Duration(seconds: 30),
        localeId: 'ko_KR',
        cancelOnError: false,
        partialResults: true,
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STT 테스트')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_text),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? '중지' : '시작'),
            ),
          ],
        ),
      ),
    );
  }
}