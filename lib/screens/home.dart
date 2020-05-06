import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:trippas/screens/trip_screen.dart';
import 'package:trippas/model/hive_model.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  initState() {
    super.initState();
    Hive.openBox('trippasTable');
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  static var trippasBox = Hive.box('trippasTable');
  int count = trippasBox.length;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Material(
              child: Transform(
            transform: Matrix4.translationValues(animation.value * width, 0, 0),
            child: Scaffold(
              body: ListView(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).primaryColorLight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Hello, boss',
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                CupertinoButton(
                                    minSize: 20,
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    disabledColor: Color(0xFF556DFE),
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    child: count == 1
                                        ? Text('$count trip',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14))
                                        : Text('$count trips',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                    onPressed: null),
                              ],
                            ),
                          ),
                          Text(
                            'Create your\ntrips with us',
                            style: TextStyle(
                                fontFamily: 'SourceCodePro',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                height: 1.2,
                                letterSpacing: 0.1),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Container(
                              // margin: EdgeInsets.only(top:10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.75,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                child: _buildListView(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                  hoverColor: Theme.of(context).primaryColor,
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      navigateToTripScreen(0, 'Add Trip');
                    });
                  }),
            ),
          ));
        });
  }

  Color tripTypeColor(String tripType) {
    switch (tripType) {
      case 'Business':
        return Colors.blue[900];
        break;
      case 'Education':
        return Colors.amber;
        break;
      case 'Health':
        return Colors.red[500];
        break;
      case 'Vacation':
        return Colors.lightBlueAccent;
        break;
      default:
        return Colors.deepOrangeAccent;
    }
  }

  Widget dropDown(int index) {
    List<String> _choice = ['Update', 'Delete'];
    return DropdownButton(
      underline: Text(''),
      icon: Icon(Icons.more_vert, color: Colors.grey, size: 20),
      iconDisabledColor: Colors.grey,
      iconEnabledColor: Colors.grey,
      items: _choice.map((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)));
      }).toList(),
      onChanged: (String newTripType) {
        setState(() {
          switch (newTripType) {
            case 'Update':
              setState(() {
                navigateToTripScreen(index, 'Update Trip');
              });
              break;
            case 'Delete':
              trippasBox.deleteAt(index);
              setState(() {
                count = trippasBox.length;
              });
              return; //_deleteTrip(context, trip);
              break;
            default:
          }
        });
      },
    );
  }

  void navigateToTripScreen(int index, String buttonText) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TripScreen(buttonText, index);
    }));
  }

  ListView _buildListView() {
    final trippasBox = Hive.box('trippasTable');
    return ListView.builder(
        itemCount: trippasBox.length,
        itemBuilder: (BuildContext context, int index) {
          final trip = trippasBox.getAt(index) as Trippas;
          return GestureDetector(
            onTap: () {
              setState(() {
                navigateToTripScreen(index, 'Update Trip');
              });
            },
            child: Card(
                child: Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.departure,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.departureDate,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.departureTime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.rotate(
                            angle: pi * 180 / 360,
                            child: Icon(Icons.flight,
                                color: Colors.grey, size: 20),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.destination,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.destinationDate,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    trip.destinationTime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: tripTypeColor(trip
                                    .tripType), //getTripTypeColor(this.tripList[index].tripType),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            width: 60,
                            height: 20,
                            child: Center(
                              child: Text(
                                trip.tripType, //getTripType(this.tripList[index].tripType),
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          ),
                          dropDown(index),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          );
        });
  }
}
