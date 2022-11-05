import 'dart:html';

import 'package:flutter/material.dart';
import 'package:quize_app_test/model/api_adapter.dart';
import 'package:quize_app_test/model/model_quiz.dart';
import 'package:quize_app_test/screen/screen_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//여러 사이즈의 하드웨어에 맞추기 위한 용도
//높이 패딩 등이 유동적으로 움직임
class _HomeScreenState extends State<HomeScreen>{
  //buffering을 알림
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //앱은 퀴즈풀기 버튼을 눌렀을 때, api 호출
  List<Quiz> quizs = [];
  bool isLoading = false;
  _fetchQuizs() async{
    setState((){
      isLoading = true;
    });
    final response = 
      await http.get(Uri.parse('https://first-flutter-drf-app.herokuapp.com/quiz/3/'));
    if(response.statusCode == 200){
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    }
    else{
      throw Exception('failed to load data');
    }
  }
  @override
  Widget build(BuildContext context){
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //key: _scaffoldKey,
        appBar: AppBar(
          title: Text('My Quiz App'),
          backgroundColor: Colors.deepPurple,
          leading:Container() //앱 bar 좌측의 버튼을 지우는 효과, 뒤로가기 등 삭제
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'images/quiz.jpg',
                width:width*0.8, 
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width*0.024),
            ),
            Text(
              '플러터 퀴즈 앱',
              style: TextStyle(
                fontSize: width*0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(width*0.048),
            ),
            _buildStep(width, '1. 랜덤으로 3개 선택.'),
            _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 후 문제 버튼을 눌러주세요.'),
            _buildStep(width, '3. 만점을 향해 도전해보세요'),
            Padding(
              padding: EdgeInsets.all(width*0.048),
            ),
            Container(
              padding: EdgeInsets.only(bottom: width*0.035),
              child:Center(
                child: ButtonTheme(
                  minWidth: width*0.8,
                  height: height*0.05,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      '지금 퀴즈 풀기',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      /*_scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Row(children: <Widget>[
                            CircularProgressIndicator(),
                            Padding(
                              padding: EdgeInsets.only(left: width*0.036),
                            )
                            Text('로딩 중 ....'),
                          ],
                        ),
                      ),
                      );*/
                      _fetchQuizs().whenComplete((){
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              quizs: quizs,
                            ),
                          ),
                        );
                      });
                    }, 
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildStep(double width, String title){
    return Container(
      padding: EdgeInsets.fromLTRB(
        width*0.048,
        width*0.024,
        width*0.048,
        width*0.024,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width*0.04,
            ),
          Padding(padding: EdgeInsets.only(right:width*0.024),
          ),
          Text(title),
        ]
      ),
    );
  }
}