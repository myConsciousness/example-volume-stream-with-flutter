import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

final TwitterApi _twitter = TwitterApi(bearerToken: 'YOUR_TOKEN_HERE');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Example Volume Stream',
      home: ExampleVolumeStream(),
    );
  }
}

class ExampleVolumeStream extends StatelessWidget {
  const ExampleVolumeStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _twitter.tweetsService.connectFilteredStream(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              return StreamBuilder(
                stream: snapshot.data,
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final TwitterResponse response = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${response.data.id}'),
                      Text('TEXT: ${response.data.text}'),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
}
