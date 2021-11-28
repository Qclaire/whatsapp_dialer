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
  bool _input=false;
  TextEditingController _numberController = TextEditingController();

  Future<String> _getCopiedText() => FlutterClipboard.paste().then((value)=> value.replaceAll(" ", ""));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pasteFromClipboard();
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
    setState(() {
      _input = _numberController.value.text.toString().length > 0;
    });
    if (isForeground) {

      return pasteFromClipboard();
    }

  }

  pasteFromClipboard(){
    return FlutterClipboard.paste().then((value) {
      if (!isValidPhoneNumber(value)) return setMessage("clipboard");
      setState((){
        _numberController.text = value.replaceAll(" ", "");
      });
    });
  }

  void _dialNumber()async{
    if (_numberController.value.text == "") {
      return pasteFromClipboard();
    }
    String _number = _numberController.value.text.toString().replaceAll(" ", "");
    if (!isValidPhoneNumber(_number)) return setMessage("invalid");
    var urlToLaunch = "http://wa.me/${formatNumber(_number, _countryCode)}";
    print(urlToLaunch);
    if(!await canLaunch(urlToLaunch)) setMessage("can't launch");

    else launch(urlToLaunch);
    }


     String formatNumber(String number, code){
      String output;
      if (number.contains("+") && number.length>10) output = number;
      else if (number.length == 10 || number.length == 9) output = "${code+number}";
      else if (number.length<15 && number.length > 10) output = number;

      return output;
    }

    void setMessage(String errorCode){
    String _msg;
    switch(errorCode){
      case "short":
        _msg= "You need at least 10";
        break;
      case "invalid":
        _msg = "Enter a valid  phone number";
        break;
      case "clipboard":
        _msg  = "No valid number on clipboard";
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
          onInit: (code)=> _countryCode = code.toString(),

            textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize:18,),
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
                    onChanged: (val){setState((){
                      _input=val.length>0;
                      msg = "";
                    });},
                  ),
                  Text(msg,style: TextStyle(fontSize: 16, color: Colors.redAccent),),
                  _input ? TextButton(onPressed: (){_numberController.clear();}, child: Text("Clear Text", style: TextStyle(color: Colors.grey, fontSize: 18),)):SizedBox.shrink()
                ],
              ),
            ),
            TextButton(onPressed: _dialNumber,
              style: TextButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(vertical: 20, horizontal:10),
                  fixedSize: Size(MediaQuery.of(context).size.width*.90, MediaQuery.of(context).size.height*.10), elevation: 10.0),
              child: Text("${!_input ? "Paste from clipboard": "Open in WhatsApp"}",style: TextStyle(fontSize: 20, color: Colors.white),),
            )
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
