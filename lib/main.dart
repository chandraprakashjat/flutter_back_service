

import 'dart:async';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:screenshot/screenshot.dart';

import 'PostFile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Auto Capture Photo Screenshot'),
    );
  }
}

class MyHomePage extends StatefulWidget
{

  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const platform = MethodChannel('com.share.flutterbackservice/service');
  ScreenshotController _screenshotController = ScreenshotController();
  var fileList = List<PostFile>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Screenshot(
      controller: _screenshotController,
      child:  _gridView(),
      ),



    floatingActionButton: FloatingActionButton(child: Icon(Icons.stop,color: Colors.red,),onPressed: (){_stopExam();},),

    );
  }

  @override
  void initState() {
    super.initState();
    connectToService();
  }

  Future<void> connectToService() async {
    try {
      getCaptureImageData();
      await platform.invokeMethod<void>('connect');

    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<String> getDataFromService() async {
    try {
      final result = await platform.invokeMethod<String>('start');
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return 'No Data From Service';
  }


  void getCaptureImageData()
  {

    Timer.periodic(Duration(seconds:40), (timer)
    {

     getDataFromService().then((value)
     {

      var time = formatDate(DateTime.now(),[HH, ':', nn, ':', ss, ' ', am]);
       fileList.add(PostFile(file:File(value),viewType: 'image',captureTime: time));
      _takeScreenShot();

     });
    });
  }




  Widget _gridView() {
    return GridView.count(
      crossAxisCount: 4,
      padding: EdgeInsets.all(4.0),
      childAspectRatio: 8.0 / 9.0,
      children: fileList.map((Item)
        {
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                  margin: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Item.viewType=='image'?Colors.orange:Colors.blueGrey, //                   <--- border color
                      width: 2.0,
                    ),
                    borderRadius:  BorderRadius.circular(10)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      Item.file,
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(margin: EdgeInsets.all(10),child: Text(Item.captureTime,style: TextStyle(fontSize: 8),),)


            ],
          );
        },
      ).toList(),
    );
  }

  void _takeScreenShot() {
    _screenshotController.capture().then((File image) {
      //Capture Done
      var time = formatDate(DateTime.now(),[HH, ':', nn, ':', ss, ' ', am]);
      fileList.add(PostFile(file: image,viewType: 'screen',captureTime: time));
      setState(() {

      });

    }).catchError((onError) {
      print(onError);
    });
  }

  void _stopExam()
  {

  }
}


