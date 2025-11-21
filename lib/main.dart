import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/cafe-template.jpg', width: 300),
              Text(
                'CAFETERIA LEDGER',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffffa701),
                ),
              ),
              Text('APP',
                  style: TextStyle(
                    color: Color(0xffffa701),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 100),
              Text('coming soon...',
                  style: TextStyle(
                    color: Color(0xffaba2a2),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    ),
  );
}
