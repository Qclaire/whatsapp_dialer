import 'package:clipboard/clipboard.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_dialer/Helpers.dart';


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
  String _countryCode;
  String msg = '';

  // Future<bool>_getCopiedText()=>FlutterClipboard.paste().then((value)=> isValidPhoneNumber(value));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);


  }

  @override
  void dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    //if(state==AppLifecycleState.inactive || state == AppLifecycleState.detached) return;
    final isForeground =  state == AppLifecycleState.resumed;
    if (isForeground){

    }
  }

  _dialNumber()async{
    var urlToLaunch = "http://wa.me/${formatNumber()}";
    print(urlToLaunch);
    if(!await canLaunch(urlToLaunch)) setMessage("can't launch");

    else launch(urlToLaunch);
    }

    bool _validInput(){
      if (isValidPhoneNumber(_number) && _countryCode.length>1) return true;
      return false;
    }

     formatNumber(){
      if (_number.length == 10 || _number.length == 9) return "${_countryCode+_number}";
      if (15<_number.length && _number.length > 10) return _number;
    }

    setMessage(String errorCode){
    String _msg;
    switch(errorCode){
      case "short":
        _msg= "You need at least 10";
        break;
      case "invalid":
        _msg = "Enter a valid number";
        break;
      default:
        _msg = "Sorry! Couldn't dial number";
    }
    setState(() {
      msg = _msg;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [CountryCodePicker(
            onChanged: (CountryCode code)=>{setState(() {
              _countryCode = code.toString();
            })},
            initialSelection: "GH",
          onInit: (code)=>_countryCode = code.toString()
          )]
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

             Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("From your clipboard: "),
                Text("", style: TextStyle(color: Colors.green, fontSize: 15, fontWeight: FontWeight.w900,),),

              ],
            ),


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
