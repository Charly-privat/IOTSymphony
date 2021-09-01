import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

const grey = Color(0xFF353535);
var sliderValue = 0.0;

bool flagButton = false;
Icon btnPlayPause = new Icon(
  Icons.play_arrow,
  color: Color(0xFF353535),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Technique IOT Symphony',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFF353535)),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

var _animationController;

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Header(),
        body: Container(
          margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/img_musique.jpg'),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        'Titre de Musique',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Artiste',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      Text(
                        '24 bits / 192KHz',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey),
                      ),
                    ],
                  )),
              Container(
                child: Slider(
                    min: 0.0,
                    max: 100.0,
                    divisions: 100,
                    value: sliderValue,
                    activeColor: Colors.amber[200],
                    inactiveColor: Colors.grey,
                    onChanged: (newValue) {
                      setState() {
                        sliderValue = newValue;
                      }
                    }),
              ),
              Container(
                child: IconButton(
                  iconSize: 25,
                  splashColor: Colors.white,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    color: Colors.grey,
                  ),
                  onPressed: () => _handleOnPressed(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavBar());
  }

  void _handleOnPressed() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();

      launchFavMusic();
    });
  }

  void launchFavMusic() {
    Uri apiUrl = Uri.parse("http://ws.audioscrobbler.com/2.0/?method=geo.gettoptracks&country=spain&api_key=bd5b4d65162a4a9a61fabdaffe713ac7&format=json");
    Uri testUrl = Uri.parse("http://www.last.fm/user/CharlyPrivat");
    Uri loginUrl = Uri.parse(
        "http://www.last.fm/api/auth/?api_key=bd5b4d65162a4a9a61fabdaffe713ac7");
    dynamic data;


    http.get(apiUrl).then((response){
      data = json.decode(response.body);
      print(data['tracks']['track'][0]['name']);
    }).catchError((err){
      print(err);
    });




  }
}

class Header extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => new Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(
          'Ma musique',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        backgroundColor: grey);
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      fixedColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xFF262626),
      items: [
        BottomNavigationBarItem(
          icon: new Icon(CupertinoIcons.music_albums_fill),
          label: 'Musique',
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.play_arrow),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: new Icon(CupertinoIcons.music_house_fill),
          label: 'Multiroom',
        )
      ],
    );
  }
}
