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
  String _countryCode;
  String msg = '';
  TextEditingController _numberController = TextEditingController();

  Future<String>_getCopiedText()=>FlutterClipboard.paste().then((value)=> value.replaceAll(" ", ""));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FlutterClipboard.paste().then((value){
      setState(() {
        _numberController.text = value.replaceAll(" ", "");
      });
    });

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

      FlutterClipboard.paste().then((value) => setState((){
        print("\n\nClipboard content: ${isValidPhoneNumber(value)} $value\n\n");
        _numberController.text = value.replaceAll(" ", "");
      }));
    }
  }

  _dialNumber()async{
    var urlToLaunch = "http://wa.me/${formatNumber(_numberController.value, _countryCode)}";
    print(urlToLaunch);
    if(!await canLaunch(urlToLaunch)) setMessage("can't launch");

    else launch(urlToLaunch);
    }

    bool _validInput(n){
      if (isValidPhoneNumber(n)) return true;
      return false;
    }

     formatNumber(num, code){
    var number = num;

      if (number.length == 10 || number.length == 9) return "${code+number}";
      if (15<number.length && number.length > 10) return number;
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

            Padding(
              padding: const EdgeInsets.only(left:18.0, right: 18.0, top: 18.0, bottom: 20,),
              child: Column(
                children: [

                  TextFormField(
                    controller: _numberController,
                    autofocus: true,
                    decoration: InputDecoration( contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))),
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    validator:(number){
                      if (number.length > 9 && !isValidPhoneNumber(number))
                        return "Doesn't look like a valid number";
                      return "";
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
