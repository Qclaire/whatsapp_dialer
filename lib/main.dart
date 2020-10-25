import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Dialer',
      theme: ThemeData(

        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Dialer(title: 'Whatsapp Dialer'),
    );
  }
}

class Dialer extends StatefulWidget {
  Dialer({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DialerState createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  String _number;
  String msg = '';

  _dialNumber(){
    if(_number[0] =="0" && _number.length == 10){

    }
      //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Please input the number you wish to open in whatsApp"),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextFormField(
                decoration: InputDecoration(icon: Icon(Icons.phone), contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                style: TextStyle(fontSize: 30),
                autofocus: true,
                maxLength: 12,
                keyboardType: TextInputType.phone,
                onChanged:(number){
                  setState(() {
                    msg = "";
                    _number = number;
                  });
                },
              ),
            ),
            Text(msg,style: TextStyle(fontSize: 16, color: Colors.redAccent),),

            FlatButton(onPressed: _dialNumber,
              color: Colors.green,
              textColor: Colors.white,

              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 50),
              child: Text("Open in WhatsApp",style: TextStyle(fontSize: 25),),
            )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
