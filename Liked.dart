import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Presentation.dart';
import 'detailpage.dart';

class Liked extends StatefulWidget {
  const Liked({Key? key}) : super(key: key);

  @override
  _LikedState createState() => _LikedState();
}

class _LikedState extends State<Liked> {

  late List<String>? likedID = [];
  late List<String>? likedName = [];
  late List<String>? likedUrl = [];
  late List<String>? likedImageUrl = [];

  @override
  void initState() {
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
    }).then((value) {setState(() {});
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

    return WillPopScope(
      onWillPop: () async{
        Navigator.pushReplacementNamed(context, "/");
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ListView(
              children: List<Widget>.generate(likedID!.length, (index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){return  DetailPage(url: likedUrl![index]);}));
                    },
                    child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: width/411 * width,
                            height: 200/411 * width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              child: Image.network(likedImageUrl![index],
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
                                child: Text(likedName![index],
                                  style: TextStyle(color: Colors.white, fontSize: 20),),
                              ),
                            ],
                          )
                        ]
                    ),
                  ),
                );
              }
              )
          )
      ),
    );
  }

}
