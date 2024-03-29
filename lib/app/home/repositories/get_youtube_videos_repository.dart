import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:skeefiapp/app/core/errors/error_handle.dart';
import 'package:skeefiapp/app/core/errors/failure.dart';
import 'package:skeefiapp/app/home/domain/entities/youtube_entity.dart';
import 'package:skeefiapp/app/home/domain/errors/channel_not_found_error.dart';

import '../domain/adapter/youtube_channel_entity_adapter.dart';
import '../domain/adapter/youtube_video_adapter.dart';

abstract class GetYoutubeVideosRepository {
  Future<Either<Failure, YoutubeChannelEntity>> fetchChannel({required String channelId});
}

class GetYoutubeVideosRepositoryImpl implements GetYoutubeVideosRepository {
  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';
  final YoutubeChannelEntityAdapter channelEntityAdapter = YoutubeChannelEntityAdapter();

  @override
  Future<Either<Failure, YoutubeChannelEntity>> fetchChannel({required String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': dotenv.env['YOUTUBE_API_KEY'] ?? '',
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );

    try {
      var response = await http.get(uri, headers: headers);

      if (response.body.isEmpty) {
        return Left(ChannelNotFoundError(errorMessage: 'Channel is empty'));
      }

      if (response is Left) {
        return Left(ChannelNotFoundError(errorMessage: 'Channel not Found'));
      }

      Map<String, dynamic> data = jsonDecode(response.body)['items'][0];

      YoutubeChannelEntity channel = channelEntityAdapter.fromJson(data);
      // print(response.body);
      // Fetch first batch of videos from uploads playlist

      channel.videos = await fetchVideosFromPlaylist(playlistId: channel.uploadPlaylistId ?? '');

      return Right(channel);
    } on Failure catch (e, s) {
      ErrorHandle.externalErrorHandle(e.toString(), stackTrace: s);
      return Left(ChannelNotFoundError(errorMessage: e.toString()));
    } catch (e, s) {
      ErrorHandle.externalErrorHandle(e.toString(), stackTrace: s);
      return Left(ChannelNotFoundError(errorMessage: e.toString()));
    }
  }

  Future<List<YoutubeVideo>> fetchVideosFromPlaylist({required String playlistId}) async {
    final adapter = YoutubeVideoEntityAdapter();

    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '100',
      'pageToken': _nextPageToken,
      'key': dotenv.env['YOUTUBE_API_KEY'] ?? '',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      // Fetch first eight videos from uploads playlist
      List<YoutubeVideo> videos = [];
      for (var json in videosJson) {
        videos.add(
          adapter.fromJson(json['snippet']),
        );
      }
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
