import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/skee_ui/skee_ui.dart';
import '../../widgets/we_text.dart';
import '../domain/models/youtube_model.dart';

class YoutuveVideoPlayerScren extends StatefulWidget {
  final YoutubeModel channel;
  const YoutuveVideoPlayerScren({
    Key? key,
    required this.channel,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  State<YoutuveVideoPlayerScren> createState() => _YoutuveVideoPlayerScrenState();
}

class _YoutuveVideoPlayerScrenState extends State<YoutuveVideoPlayerScren> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        startAt: 5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WEPalette.backgroudColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: WEPalette.backgroudColor,
        ),
        body: Column(
          children: [
            WEText.custom('@YoutubechannelName', color: Colors.grey),
            const Text(
              'ola gustavo',
              style: TextStyle(color: Colors.red),
            ),
            WEText.title(widget.channel.title, color: Colors.white),
            Center(
              heightFactor: 2,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                onReady: () {
                  print('Player is ready.');
                },
              ),
            ),
            WEText.custom(
                "This channel will be avaliable for 7 more days, \n then a new channel will be added. If you desire, continue fallowing this channel on Youtube",
                color: Colors.grey,
                textAlign: TextAlign.center)
          ],
        ));
  }
}