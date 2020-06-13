import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Pass extends StatefulWidget {
  @override
  String eventCode;
  Pass(this.eventCode);
  _PassState createState() => _PassState();
}

class _PassState extends State<Pass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Center(
          child: QrImage(
            data: widget.eventCode,
            version: QrVersions.auto,
            size: 200.0,
          ),
        )
      ),
    );
  }
}