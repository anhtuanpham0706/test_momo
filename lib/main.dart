import 'package:flutter/material.dart';
import 'dart:async';
import 'package:momo_vn/momo_vn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MomoVn _momoPay;
  PaymentResponse _momoPaymentResult;
  String _payment_status;
  @override
  void initState() {
    super.initState();
    _momoPay = MomoVn();
    _momoPay.on(MomoVn.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _momoPay.on(MomoVn.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPlatformState();
  }
  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('THANH TOÁN QUA ỨNG DỤNG MOMO'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                child: Text('DEMO PAYMENT WITH MOMO.VN'),
                onPressed: () async {
                  MomoPaymentInfo options = MomoPaymentInfo(
                      merchantname: "Công ty TNHH Delichill Việt Nam",
                      appScheme: "1221212",
                      merchantcode: 'MOMOY3W720210311',
                      amount: 27000,
                      orderId: '22E031500718',
                      orderLabel: 'Thanh Toán Hóa Đơn ',
                      merchantnamelabel: "Công ty TNHH Delichill Việt Nam",
                      fee: 0,
                      description: 'Thanh Toán Hóa Đơn ADVN',
                      username: '0929317227',
                      partner: 'merchant',
                      extra: "{\"key1\":\"value1\",\"key2\":\"value2\"}",
                      isTestMode: true
                  );
                  try {
                    _momoPay.open(options);
                  } catch (e) {
                    debugPrint(e);
                  }
                },
              ),
              Text(_payment_status ?? "CHƯA THANH TOÁN")
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _momoPay.clear();
  }
  void _setState() {
    _payment_status = 'Đã chuyển thanh toán';
    if (_momoPaymentResult.isSuccess) {
      _payment_status += "\nTình trạng: Thành công.";
      _payment_status += "\nSố điện thoại: " + _momoPaymentResult.phonenumber;
      _payment_status += "\nExtra: " + _momoPaymentResult.extra;
      _payment_status += "\nToken: " + _momoPaymentResult.token;
    }
    else {
      _payment_status += "\nTình trạng: Thất bại.";
      _payment_status += "\nExtra: " + _momoPaymentResult.extra;
      _payment_status += "\nMã lỗi: " + _momoPaymentResult.status.toString();
    }
  }
  void _handlePaymentSuccess(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState(

      );

    });
    print("THÀNH CÔNG: " + response.phonenumber);
    // Fluttertoast.showToast(msg: "THÀNH CÔNG: " + response.phonenumber, timeInSecForIos: 4);
  }

  void _handlePaymentError(PaymentResponse response) {
    setState(() {
      _momoPaymentResult = response;
      _setState();
    });
    print("THẤT BẠI: " + response.message.toString());
    // Fluttertoast.showToast(msg: "THẤT BẠI: " + response.message.toString(), timeInSecForIos: 4);
  }
}