import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rajasthanstudio/Bloc/Bolc.dart';
import 'package:rajasthanstudio/Bloc/Event.dart';
import 'package:rajasthanstudio/Bloc/State.dart';
import 'package:rajasthanstudio/Liked.dart';
import 'package:rajasthanstudio/detailpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Data/Repo.dart';

class Presentation extends StatefulWidget {
  const Presentation({Key? key}) : super(key: key);
  @override
  _PresentationState createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  late List<String>? likedID = [];
  late List<String>? likedName = [];
  late List<String>? likedUrl = [];
  late List<String>? likedImageUrl = [];

  @override
  void initState() {
    BlocProvider.of<CoursesBloc>(context).add(InitialFetch());
    bool hasConnection = true;
    DataConnectionChecker().hasConnection.then((value) {
      hasConnection = value;
    });
    DataConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        switch(status){
          case DataConnectionStatus.connected:
            hasConnection = true;
            print("BlockProvided.....................");
            BlocProvider.of<CoursesBloc>(context).add(InitialFetch());
            break;
          case DataConnectionStatus.disconnected:
            hasConnection = false;
            break;
        }
      });
    });

    SharedPreferences.getInstance().then((prefs) {
      likedID = prefs.getStringList("likedID");
      likedName = prefs.getStringList("likedName");
      likedUrl = prefs.getStringList("likedUrl");
      likedImageUrl = prefs.getStringList("likedImageUrl");
    }).then((value) {
      if(likedID == null){
        likedID = [];
        likedName = [];
        likedImageUrl = [];
        likedUrl = [];
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
        body: BlocBuilder<CoursesBloc, BlocState>(
          builder: (context, state) {
            return BlocProvider.of<CoursesBloc>(context).state is InitialState ?
            Center(child: CircularProgressIndicator(color: Colors.deepOrange,))
                :
            NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if(notification.metrics.pixels == notification.metrics.maxScrollExtent){
                  BlocProvider.of<CoursesBloc>(context).add(FetchEvent(length: BlocProvider.of<CoursesBloc>(context).photos.length + 15));
                }
                print(notification.metrics.maxScrollExtent);
                print(notification.metrics.pixels);
                return true;
              },
                  child: ListView(
                    children: List<Widget>.generate(BlocProvider.of<CoursesBloc>(context).photos.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(left: 20.0/411 * width, right: 20.0/411 * width, top: 25/411 * width),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: BlocProvider.of<CoursesBloc>(context),
                                  child: DetailPage(url: BlocProvider.of<CoursesBloc>(context).photos[index].photographerurl)
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: width/411 * width,
                                  height: 200/411 * width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(BlocProvider.of<CoursesBloc>(context).photos[index].src.medium,
                                      fit: BoxFit.fitWidth,
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Image.asset("assets/avatar.png",
                                          height: 137/411 * width,
                                          width:  234/411 * width,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(BlocProvider.of<CoursesBloc>(context).photos[index].photographer,
                                        style: TextStyle(color: Colors.white, fontSize: 20),),
                                    ),
                                    IconButton(
                                        onPressed: (){

                                          if(likedID!.contains((BlocProvider.of<CoursesBloc>(context).photos[index].id.toString()))){

                                            likedID!.remove(BlocProvider.of<CoursesBloc>(context).photos[index].id.toString());
                                            likedName!.remove(BlocProvider.of<CoursesBloc>(context).photos[index].photographer);
                                            likedUrl!.remove(BlocProvider.of<CoursesBloc>(context).photos[index].photographerurl);
                                            likedImageUrl!.remove(BlocProvider.of<CoursesBloc>(context).photos[index].src.medium);

                                            SharedPreferences.getInstance().then((prefs) {
                                              prefs.setStringList("likedID", likedID!);
                                              prefs.setStringList("likedName", likedName!);
                                              prefs.setStringList("likedUrl", likedUrl!);
                                              prefs.setStringList("likedImageUrl", likedImageUrl!);
                                            });
                                          }
                                          else{
                                            SharedPreferences.getInstance().then((prefs) {
                                              likedID!.add(BlocProvider.of<CoursesBloc>(context).photos[index].id.toString());
                                              likedName!.add(BlocProvider.of<CoursesBloc>(context).photos[index].photographer);
                                              likedUrl!.add(BlocProvider.of<CoursesBloc>(context).photos[index].photographerurl);
                                              likedImageUrl!.add(BlocProvider.of<CoursesBloc>(context).photos[index].src.medium);
                                              prefs.setStringList("likedID", likedID!);
                                              prefs.setStringList("likedName", likedName!);
                                              prefs.setStringList("likedUrl", likedUrl!);
                                              prefs.setStringList("likedImageUrl", likedImageUrl!);
                                            });
                                          }
                                          setState(() {});
                                        },
                                        icon: Icon(likedID!.contains((BlocProvider.of<CoursesBloc>(context).photos[index].id.toString()))? Icons.favorite : Icons.favorite_border, color: Colors.deepOrange,))
                                  ],
                                )
                              ]
                          ),
                        ),
                      );
                    }
                    ) + [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    ]
                  ),
                );
          },
        )
    );
  }
}
