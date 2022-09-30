import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MaterialApp(
    home: video_demo(),
    debugShowCheckedModeBanner: false,
  ));
}

class video_demo extends StatefulWidget {
  const video_demo({Key? key}) : super(key: key);

  @override
  State<video_demo> createState() => _video_demoState();
}

class _video_demoState extends State<video_demo> {
  String path = "";

  VideoPlayerController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Video Player"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  XFile? video =
                      await ImagePicker().pickVideo(source: ImageSource.camera);

                  path = video!.path;

                  // Uri url = Uri.parse(path);

                  // _controller = VideoPlayerController.contentUri(url);
                  _controller = VideoPlayerController.file(File(path));
                  await _controller!.initialize();
                  await _controller!.play();

                  setState(() {});
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: path.isEmpty
            ? Center(
                child: Container(
                  height: 400,
                  width: 400,
                  color: Colors.black,
                  child: Text("No Video Selected"),
                ),
              )
            : (_controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : Container()),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller!.value.isInitialized) {
                _controller!.value.isPlaying
                    ? _controller!.pause()
                    : _controller!.play();
              }
              ;
            });
          },
          child: Icon(path.isNotEmpty
              ? (_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow)
              : Icons.play_arrow),
        ));
  }
}
