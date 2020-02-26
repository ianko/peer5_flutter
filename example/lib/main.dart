import 'package:flutter/material.dart';
import 'dart:async';
import 'package:peer5/peer5.dart';
import 'package:peer5_example/video_player.dart';

void main() => runApp(MyApp());

/// Main example widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _controller = TextEditingController(text: '');
  String _streamUrl;

  @override
  void initState() {
    super.initState();
    _initPeer5();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_onTextChange);
    _controller.dispose();
  }

  void _onTextChange() {
    setState(() {});
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPeer5() async {
    await Peer5.initWithToken('__YOUR_PEER5_TOKEN__');
    print('Peer5 initialized: ${Peer5.initialized}');
  }

  Future<void> _getStreamUrl() async {
    if (_controller.text.isNotEmpty) {
      _streamUrl = await Peer5.getStreamUrl(_controller.text);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Video Player')),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      maxLines: 1,
                      autocorrect: false,
                      cursorWidth: 10.0,
                      keyboardType: TextInputType.url,
                      controller: _controller,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(labelText: 'Video URL'),
                    ),
                  ),
                  InkWell(
                    onTap: _controller.clear,
                    child: Ink(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.delete_forever,
                        size: 25.0,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: _controller.text.isEmpty ? null : _getStreamUrl,
                child: const Text('PLAY VIDEO'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                elevation: 30.0,
              ),
              Divider(),
              if (_streamUrl != null)
                Expanded(child: VideoPlayerDemo(url: _streamUrl)),
            ],
          ),
        ),
      ),
    );
  }
}
