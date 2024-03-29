import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../core/skee_ui/skee_ui.dart';
import '../../widgets/skee_text.dart';
import '../domain/entities/youtube_entity.dart';

class YoutuveVideoPlayerScren extends StatefulWidget {
  final YoutubeChannelEntity? channel;
  const YoutuveVideoPlayerScren({
    Key? key,
    this.channel,
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
    _init();
  }

  void _init() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(mute: false, autoPlay: true, startAt: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: SkeePalette.backgroudColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: SkeePalette.backgroudColor,
        ),
        body: Column(
          children: [
            // View Header
            //
            SkeeText.custom('@YoutubechannelName', color: Colors.grey),
            SkeeText.title(widget.channel?.title ?? '', color: Colors.white),

            // Youtube video
            //
            Center(
              heightFactor: 2,
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),

            // Message
            //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SkeeText.custom(
                  "This channel will be avaliable until the next app \n release, then a new channel will be added. If you desire, continue fallowing this channel on Youtube",
                  color: Colors.grey,
                  textAlign: TextAlign.center),
            )
          ],
        ));
  }
}
