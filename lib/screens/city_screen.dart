import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utilities/constants.dart';

class CityScreen extends StatefulWidget {
  final Color currentColor;
  const CityScreen({Key key, this.currentColor}) : super(key: key);
  @override
  _CityScreenState createState() => _CityScreenState(currentColor);
}

class _CityScreenState extends State<CityScreen> {
  final Color currentColor;
  String city = '';

  _CityScreenState(this.currentColor);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        backgroundColor: currentColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        //constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(30),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.white), //color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    hintText: 'Search for City',
                    //hintStyle: TextStyle(color: Colors.grey[400]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide.none
                    )
                  ),
                  onChanged: (value) {
                    city = value.trim();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, city),
                  child: Text(
                    'Get Weather',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      //fontFamily: 'Spartan MB',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}