import 'package:firebase_learning_project/Screens/Welcome/components/body.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

      Position? _currentPosition;

      var dialogOpen;

  Future _checkGeolocationPermission() async {
    LocationPermission geolocationStatus = await Geolocator.checkPermission();
    print("geolocationStatus = $geolocationStatus");

    if (geolocationStatus == LocationPermission.denied && dialogOpen == null) {
      dialogOpen = _showDeniedDialog();
    } else if (geolocationStatus == LocationPermission.deniedForever &&
        dialogOpen == null) {
      dialogOpen = _showDeniedForeverDialog();
    } else if (geolocationStatus == LocationPermission.whileInUse ||
        geolocationStatus == LocationPermission.always) {
      print('GeolocationStatus.granted');

      if (dialogOpen != null) {
        Navigator.of(context, rootNavigator: true).pop();
        dialogOpen = null;
      }
    }
  }

    // this also checks for location permission.
  Future<void> _initCurrentLocation() async {
    Position? currentPosition;
    try {
      currentPosition =
          await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print("position = $currentPosition");

      setState(() => _currentPosition = currentPosition);
    } catch (e) {
      currentPosition = null;
      print("_initCurrentLocation#e = $e");
    }

    if (!mounted) return;

    setState(() => _currentPosition = currentPosition);
  }

  Future _showDeniedDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: Text('Access to location denied'),
            content: Text('Allow access to the location services.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  _initCurrentLocation();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _showDeniedForeverDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.of(context, rootNavigator: true).pop();
            return true;
          },
          child: AlertDialog(
            title: Text('Access to location permanently denied'),
            content: Text('Allow access to the location services for this App using the device settings.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Geolocator.openAppSettings();
                  dialogOpen = null;
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _initCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    //   _checkGeolocationPermission();
    //   if (_currentPosition == null) _initCurrentLocation();

    // if (_currentPosition != null && dialogOpen != null)
    //   Navigator.of(context, rootNavigator: true).pop();
    return SafeArea(
      child: Scaffold(
        body: Body(),
      ),
    );
  }
}
