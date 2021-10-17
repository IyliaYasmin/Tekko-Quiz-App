import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:tekko/screens/root/root.dart';
import 'package:tekko/services/database.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// to scan QR code
class QrScan extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScanState();
}

class _QrScanState extends State<QrScan> {
  String qrCodeResult = 'Unknown'; //default

    void _joinGroup(BuildContext context, String groupId) async {
     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

      String groupName, groupImg;
      await FirebaseFirestore.instance.collection("groups").doc(groupId).get().then((addGroupId) => groupName = addGroupId.data()['name'] );  
      await FirebaseFirestore.instance.collection("groups").doc(groupId).get().then((addGroupId) => groupImg = addGroupId.data()['groupImg'] );  
      

     String _returnString = await Database().joinGroup(groupId, _currentUser.getCurrentUser.uid, groupName, groupImg);
     print("done join");
     
     if( _returnString == "success"){
       Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context)=> LoginRoot(),
          ),
          (route) => false);
     }
    }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          elevation: 0.0,
          title: Center(
            child: Text(
              "QR Scanner",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scan Result',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'QRCodeResult: ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
                Text(
                qrCodeResult,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 72),
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text('Scan QR Code',
                  style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),),
                ),
                onPressed: () => scanQRCodeResult(),
              ),
              Text("and"),
               RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 87),
                      child: Text(
                        "Join",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    onPressed: () => _joinGroup(context, qrCodeResult),
                  ),
            ],
          ),
        ),
      );

  Future<void> scanQRCodeResult() async {
    try {
      final qrCodeResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCodeResult = qrCodeResult;
      });
    } on PlatformException {
      qrCodeResult = 'Failed to get platform version.';
    }
  }
}