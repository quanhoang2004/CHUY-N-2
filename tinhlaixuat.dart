import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InterestUI(),
    );
  }
}

class InterestUI extends StatefulWidget {
  const InterestUI({super.key});

  @override
  State<InterestUI> createState() => _InterestUIState();
}

class _InterestUIState extends State<InterestUI> {
  final moneyController = TextEditingController();
  final rateController = TextEditingController();

  String result = "";

  void calculate() {
    double money = double.tryParse(moneyController.text) ?? 0;
    double rate = double.tryParse(rateController.text) ?? 0;

    if (money <= 0 || rate <= 0) {
      setState(() {
        result = "Nhập dữ liệu hợp lệ!";
      });
      return;
    }

    double r = rate / 100;
    double years = log(2) / log(1 + r);

    setState(() {
      result = "${years.toStringAsFixed(2)} năm để gấp đôi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌸 nền sáng giống ảnh
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFBFB), Color(0xFFF3F3F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),

            // 📱 Card giống mockup iPhone
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Máy tính lãi suất",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 💰 Số tiền
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Số tiền"),
                ),
                const SizedBox(height: 5),

                TextField(
                  controller: moneyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Nhập số tiền",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 📈 Lãi
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Lãi hàng năm (%)"),
                ),
                const SizedBox(height: 5),

                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Ví dụ: 8",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // 🔘 Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: calculate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Tính toán",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 📊 Result
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    result,
                    key: ValueKey(result),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}