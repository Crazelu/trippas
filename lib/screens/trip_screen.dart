import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trippas/model/hive_model.dart';
import 'package:hive/hive.dart';

import 'home.dart';

class TripScreen extends StatefulWidget {
  final int index;
  final String buttonText;

  TripScreen(this.buttonText, [this.index]);
  @override
  _TripScreenState createState() =>
      _TripScreenState(this.buttonText, this.index);
}

class _TripScreenState extends State<TripScreen> {
  Trippas trip;
  int index;
  String buttonText;
  String name;

  _TripScreenState(this.buttonText, [this.index]);

  TextEditingController departureController = TextEditingController();
  TextEditingController departureDateController = TextEditingController();
  TextEditingController departureTimeController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationDateController = TextEditingController();
  TextEditingController destinationTimeController = TextEditingController();

  static final List<String> _tripType = [
    'Business',
    'Education',
    'Health',
    'Vacation'
  ];
  String _currentTripType = _tripType[0];
  bool isUpdate = false;
  Box trippasBox;

  @override
  void initState() {
    super.initState();
    Hive.openBox('trippasTable');
    var trippasBox = Hive.box('trippasTable');
    trip = updateValues(trippasBox);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Home();
          }));
        });
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.blueGrey[900], size: 20),
              onPressed: () {
                setState(() {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                });
              }),
          title: Text(
              buttonText == 'Add Trip' ? 'Create a trip' : 'Update trip plan',
              style: TextStyle(color: Colors.blueGrey[900])),
        ),
        body: FutureBuilder(
          future: Hive.openBox('trippasTable'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Theme.of(context).primaryColorLight,
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.75,
                        color: Theme.of(context).primaryColorLight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: <Widget>[
                              departureInputFields('Enter Departure',
                                  'Enter Date', 'Enter Time'),
                              SizedBox(
                                height: 20,
                              ),
                              destinationInputFields('Enter Destination',
                                  'Enter Date', 'Enter Time'),
                              SizedBox(
                                height: 20,
                              ),
                              textFieldWithDropDown(),
                              SizedBox(
                                height: 40,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _save(context);
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColorDark,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Text(buttonText,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )));
            } else
              return Scaffold();
          },
        ),
      ),
    );
  }

  Widget departureInputFields(
      String firstText, String secondText, String thirdText) {
    if (buttonText == 'Update Trip') {
      isUpdate = true;
    }

    if (isUpdate) {
      trip = Hive.box('trippasTable').getAt(index);
      try {
        departureController.text = trip.departure;
        departureDateController.text = trip.departureDate;
        departureTimeController.text = trip.departureTime;
      } catch (e) {
        print(e);
      }
    }

    return Column(
      children: <Widget>[
        TextField(
          controller: departureController,
          decoration: InputDecoration(
              fillColor: Colors.black,
              hintText: firstText,
              hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            updateDeparture();
          },
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: departureDateController,
                decoration: InputDecoration(
                    hintText: secondText,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  updateDepartureDate();
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: departureTimeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: thirdText,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  updateDepartureTime();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget destinationInputFields(
      String firstText, String secondText, String thirdText) {
    if (buttonText == 'Update Trip') {
      isUpdate = true;
    }

    if (isUpdate) {
      try {
        destinationController.text = trip.destination;
        destinationDateController.text = trip.destinationDate;
        destinationTimeController.text = trip.destinationTime;
      } catch (e) {
        print(e);
      }
    }

    return Column(
      children: <Widget>[
        TextField(
          controller: destinationController,
          decoration: InputDecoration(
              hintText: firstText, hintStyle: TextStyle(color: Colors.grey)),
          onChanged: (value) {
            updateDestination();
          },
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: destinationDateController,
                decoration: InputDecoration(
                    hintText: secondText,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  updateDestinationDate();
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                controller: destinationTimeController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: thirdText,
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (value) {
                  updateDestinationTime();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget textFieldWithDropDown() {
    if (buttonText == 'Update Trip') {
      isUpdate = !isUpdate;
    }

    if (isUpdate) {
      try {
        this._currentTripType = trip.tripType;
      } catch (e) {
        print(e);
      }
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            'Trip Type',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        DropdownButton(
          value: _currentTripType,
          underline: Text(''),
          iconDisabledColor: tripTypeColor(_currentTripType),
          iconEnabledColor: tripTypeColor(_currentTripType),
          items: _tripType.map((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: EdgeInsets.only(top: 13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(value,
                          style: TextStyle(
                            color: tripTypeColor(value),
                          )),
                      Divider()
                    ],
                  ),
                ));
          }).toList(),
          onChanged: (String newTripType) {
            setState(() {
              this._currentTripType = newTripType;
            });
          },
        ),
      ],
    );
  }

  void updateDeparture() {
    trip.departure = departureController.text;
  }

  void updateDepartureDate() {
    trip.departureDate = departureDateController.text;
  }

  void updateDepartureTime() {
    trip.departureTime = departureTimeController.text;
  }

  void updateDestination() {
    trip.destination = destinationController.text;
  }

  void updateDestinationDate() {
    trip.destinationDate = destinationDateController.text;
  }

  void updateDestinationTime() {
    trip.destinationTime = destinationTimeController.text;
  }

  void _save(BuildContext context) {
    if (departureController.text.isEmpty ||
        destinationController.text.isEmpty ||
        departureController.text.isEmpty &&
            destinationController.text.isEmpty) {
      showSnackBar(context);
    } else {
      var trip = Trippas(
          departureController.text,
          departureDateController.text,
          departureTimeController.text,
          destinationController.text,
          destinationDateController.text,
          destinationTimeController.text,
          _currentTripType);
      if (buttonText == 'Add Trip') {
        Hive.box('trippasTable').add(trip);
      } else {
        Hive.box('trippasTable').putAt(index, trip);
      }
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Home();
        }));
      });
    }
  }

  Trippas updateValues(Box<dynamic> trippasBox) {
    Trippas _trip;
    var trip;
    if (buttonText == 'Update Trip') {
      trip = trippasBox.getAt(index) as Trippas;
      return trip;
    } else
      return _trip;
  }

  void showSnackBar(BuildContext context) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.lightBlueAccent,
      duration: Duration(seconds: 2),
      content: Text(
        'Departure and destination has to be set',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
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
}
