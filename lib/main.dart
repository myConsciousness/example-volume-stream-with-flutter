import 'package:flutter/material.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Example Volume Stream',
      home: VolumeStreamView(),
    );
  }
}

class VolumeStreamView extends StatefulWidget {
  const VolumeStreamView({Key? key}) : super(key: key);

  @override
  State<VolumeStreamView> createState() => _VolumeStreamViewState();
}

class _VolumeStreamViewState extends State<VolumeStreamView> {
  final TwitterApi _twitter = TwitterApi(bearerToken: 'YOUR_TOKEN_HERE');

  late Future<TwitterStreamResponse<TwitterResponse<TweetData, void>>> _stream;

  @override
  void initState() {
    super.initState();

    // 15分間に50回のリクエストのみが許可されるため、
    // あらかじめStreamを取得しておきます。
    _stream = _twitter.tweets.connectSampleStream();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: FutureBuilder(
            future: _stream,
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final stream = snapshot.data.stream;

              return StreamBuilder(
                stream: stream,
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
