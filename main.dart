import 'dart:async';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rajasthanstudio/Bloc/Bolc.dart';
import 'Data/Repo.dart';
import 'Liked.dart';
import 'Presentation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return DynamicApp(
          navigator: (child!.key as GlobalKey<NavigatorState>),
          child: child,
        );
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/Liked': (context) => Liked(),
      },
      home: BlocProvider(
        lazy: false,
          create: (context) {
            return  CoursesBloc(repository: RepositoryImpl());
          },
          child: Presentation()),
    );
  }
}

class DynamicApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigator;
  final Widget child;

  DynamicApp({Key? key, required this.navigator, required this.child}) : super(key: key);
  @override
  _DynamicAppState createState() => _DynamicAppState();
}

class _DynamicAppState extends State<DynamicApp> {

  bool hasConnection = true;

  @override
  void initState() {
    DataConnectionChecker().hasConnection.then((value) {
      hasConnection = value;
    });
    DataConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        switch(status){
          case DataConnectionStatus.connected:
            hasConnection = true;
            break;
          case DataConnectionStatus.disconnected:
            hasConnection = false;
            break;
        }
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: hasConnection? Size.fromHeight(58) : Size.fromHeight(90),
          child: Column(
            children: [
             hasConnection ? Container() : Container(
               color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off),
                    SizedBox(width: 10,),
                    Text("No Internet Connection"),
                ],
                ),),
              AppBar(
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                  onPressed: (){
                    widget.navigator.currentState!.pushReplacementNamed('/Liked');
                  },
                  icon: Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.list),
                  ),
                ),
              ],
               title: Text("Hope!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ]
          ),
        ),
        body: widget.child,
      ),
    );
  }
}

