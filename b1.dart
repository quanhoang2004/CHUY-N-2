import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Member {
  final String name;
  final String studentId;
  final String birthYear;
  final String school;
  final String major;

  Member({
    required this.name,
    required this.studentId,
    required this.birthYear,
    required this.school,
    required this.major,
  });
}

class MyApp extends StatelessWidget {
  final Member member = Member(
    name: "Hoàng Hữu Quân",
    studentId: "20221882",
    birthYear: "2004",
    school: "Trường Đại học Công Nghệ Đông Á",
    major: "Công nghệ thông tin",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(member: member),
    );
  }
}

class HomePage extends StatelessWidget {
  final Member member;

  HomePage({required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thành viên"), centerTitle: true),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailPage(member: member)),
            );
          },
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text(
                    member.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("MSSV: ${member.studentId}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 🔥 Trang chi tiết
class DetailPage extends StatelessWidget {
  final Member member;

  DetailPage({required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết")),
      body: Center(
        child: Card(
          elevation: 8,
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 15),
                Text(
                  member.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("MSSV: ${member.studentId}"),
                Text("Năm sinh: ${member.birthYear}"),
                Text("Trường: ${member.school}"),
                Text("Khoa: ${member.major}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
