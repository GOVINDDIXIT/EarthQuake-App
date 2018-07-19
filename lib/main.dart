import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';


Map _data;
List _features;
void main() async
{
   _data= await getQuakes();
   _features=_data['features'];
  //print(_data['features'][0]['properties']);

  runApp(new MaterialApp(
    title: 'EarthQuakes',
    home: new Quakes(),
    debugShowCheckedModeBanner: false,
  ));
  
}

class Quakes extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:new Text('EarthQuakes'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
     
     body: new Center(
       child: new ListView.builder(
         itemCount: _features.length,
         padding: const EdgeInsets.all(15.0),
          //Date format: https://pub.dartlang.org/packages/intl#-readme-tab-
            //DateFormat: https://www.dartdocs.org/documentation/intl/0.15.1/intl/DateFormat-class.html
            //https://stackoverflow.com/questions/45357520/dart-converting-milliseconds-since-epoch-unix-timestamp-into-human-readable


         itemBuilder: (BuildContext context,int position){
           if(position.isOdd) return new Divider();
           final index=position ~/ 2;
           var format = new DateFormat.yMMMMd("en_US").add_jm();
              //var dateString = format.format(date);
           var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
                  _features[index]['properties']['time'] * 1000,
                  isUtc: true));

          return new ListTile(
            title: new Text("$date",
            style: new TextStyle(fontSize: 17.5,color: Colors.red,fontWeight: FontWeight.w500
            ) ,),

            subtitle: new Text("${_features[index]['properties']['place']}",
            style: new TextStyle(
              fontSize: 14.5,
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic
            ),),

            leading:new CircleAvatar(
              backgroundColor: Colors.green,

              child: new Text("${_features[index]['properties']['mag']}",
              style: new TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
              ),
            ),
            
          ),
           onTap: () {
                  _showAlertMessage(
                      context, "${_features[index]['properties']['title']}");
          
         },
     );
         }),
      
    ),
    );
  }
  void _showAlertMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Beware !!'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('OK'))
      ],
    );
    showDialog(context: context, child: alert);
}
}



Future<Map> getQuakes() async{
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}