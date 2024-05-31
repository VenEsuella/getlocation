import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:
        Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Get Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
        Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: Text(widget.title),
      ),
      body: const LocationWidget(),
    );
  }
}

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key});

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _locationMessage = "";
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final status = await Permission.location.status;
    if (!status.isGranted) {
      final result = await Permission.location.request();
      if (result != PermissionStatus.granted) {
        return;
      }
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _locationMessage =
      'Latitude: ${position.latitude}, Longitude:${position.longitude}';
    });
  }

  Future<void> _showOnMap() async {
    if (_currentPosition != null) {
      Uri googleMapsUrl = Uri.parse(

          'https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude},'
      '${_currentPosition!.longitude}');
      try {
        await launchUrl(googleMapsUrl);
      } catch (e) {
        throw 'Could not launch $googleMapsUrl';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_locationMessage),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Get Location'),
          ),
          const SizedBox(height: 10,),
          if (_currentPosition != null)
            ElevatedButton(
              onPressed: _showOnMap,
              child: const Text('Show on Map'),
            ),
        ],
      ),
    );
  }
}