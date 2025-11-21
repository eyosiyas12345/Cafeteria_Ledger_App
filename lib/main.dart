import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xff4b0101),
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
                    color: Colors.white,
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
