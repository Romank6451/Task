import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:Homepage(),
    );
  }
}
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final String apiUrl = "http://ninanews.com/NinaNewsService/api/values/GetLastXBreakingNews?rowsToReturn=10&fbclid=IwAR1L4RUHRiXCCjf-qzXYwIqRl6v1yozROuHOnbDZTRJiUgDIMQmYSNwRYj4";
  
  Future<List<dynamic>> fetchData() async {
    var result = await http.get(apiUrl);
    print(json.decode(result.body)['Data']);
    return json.decode(result.body)['Data'];

  }
    String _title(dynamic user){
    return user['Khabar_Title'];

  }
  String _date(dynamic user){
    return user['Khabar_Date'];

  }
  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News',style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
             // print(_age(snapshot.data[0]));
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.red,
                              child: Image(image: NetworkImage(snapshot.data[index]['Pic']),fit: BoxFit.cover,),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child:Text(_title(snapshot.data[index])) ,
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(right: 8,top: 8,bottom: 5),
                              child: Text("Date: "+_date(snapshot.data[index])),
                            ),
                          ],
                        ),
                      );
                  });
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
      ),
    );
  }
}

