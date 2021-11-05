import 'package:clipboard/clipboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


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

class _DialerState extends State<Dialer> with WidgetsBindingObserver {
  String _number;
  String msg = '';
  String _clipboard='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterClipboard.paste().then((value)=>{
      setState((){_clipboard = value;})
    });
  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state==AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isForeground =  state == AppLifecycleState.resumed;
    print("\n\n$isForeground\n\n");
    if (isForeground){
      print("isResumed");
      FlutterClipboard.paste().then((value)=>{
      print("\n\nhi there$value\n\n"),
        setState((){_clipboard = value;})
      });
    }
  }

  _dialNumber()async{
    var urlToLaunch = _number.length == 10 && _number[0] == "0" ?
    "http://wa.me/233${_number.substring(1)}" :
    "http://wa.me/$_number";

    String error;

    if (_number.length < 10) error = "${_number.length} digits; You need at least 10";
    else if (_number.length == 10 && _number[0] != "0") error = "Invalid number";
    else if(!await canLaunch(urlToLaunch)) error = "Sorry we couldn't open your number";
    if(error != null) setState(() { msg = error;});
    else launch(urlToLaunch);
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
            Column(
              children: [
                Text("Type/Paste the number below", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w900,),),
                Text("We'll open it in whatsApp"),
              ],
            ),

            _clipboard.length != 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Copied: "),
                Text("$_clipboard", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w900,),),

              ],
            ):SizedBox.shrink(),


            Padding(
              padding: const EdgeInsets.only(left:18.0, right: 18.0, top: 18.0, bottom: 20,),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration( contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged:(number){
                      setState(() {
                        if(number[0] == "+") {
                          msg = "Symbols not allowed";
                        }else {
                          msg="";
                          _number = number.replaceAll(" ", "");
                        }
                      });
                    },
                  ),
                  Text(msg,style: TextStyle(fontSize: 16, color: Colors.redAccent),),
                ],
              ),
            ),
            TextButton(onPressed: _dialNumber,
              style: TextButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 20, horizontal:10),
                  fixedSize: Size(MediaQuery.of(context).size.width*.90, MediaQuery.of(context).size.height*.10), elevation: 10.0),
              child: Text("Open in WhatsApp",style: TextStyle(fontSize: 20, color: Colors.white),),
            )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
