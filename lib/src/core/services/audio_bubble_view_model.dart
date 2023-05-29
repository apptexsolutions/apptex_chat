import 'dart:io';

import 'package:apptex_chat/src/models/base_view_model.dart';
import 'package:apptex_chat/src/models/message_model.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

Directory myTempDir = Directory.systemTemp;

class AudioBubbleViewModel extends BaseViewModel {
  String? name;
  MessageModel model;
  File? audio;
  bool isPlaying = false;

  double max = 100.0;
  double progress = 0.0;
  static var httpClient = HttpClient();
  bool fileExist = false;
  bool isDownloading = false;
  bool isInited = false;
  PlayerController playerController;

  AudioBubbleViewModel(this.model, this.playerController) {
    if (model.content.isNotEmpty) {
      name = FirebaseStorage.instance.refFromURL(model.content).name;
    }
    isFileExist();

    playerController.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.initialized) {
        max = playerController.maxDuration.toDouble();
        if (max == -1) {
          max = 100;
        }
      }

      if (state == PlayerState.playing) {
        isPlaying = true;
      } else {
        isPlaying = false;
        progress = 0;
      }
      notifyListeners();
    });

    playerController.onCompletion.listen((event) {
      isPlaying = false;
      progress = 0;
      notifyListeners();
    });

    playerController.onCurrentDurationChanged.listen((int duration) {
      progress = duration.toDouble();
      notifyListeners();
    });
  }

  downloadAudio() async {
    isDownloading = true;

    await _downloadFile(model.content, name!);

    isDownloading = false;
    isFileExist();
    notifyListeners();
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    File file = File(myTempDir.path + '/' + name!);
    await file.writeAsBytes(bytes);
    return file;
  }

  playAudio() {
    if (isPlaying) {
      playerController.seekTo(0);
      playerController.pausePlayer();
    } else {
      playerController.seekTo(0);
      playerController.startPlayer(finishMode: FinishMode.pause);
    }
  }

  isFileExist() async {
    audio = File(myTempDir.path + '/' + name!);
    if (await audio!.exists()) {
      fileExist = true;
      playerController.preparePlayer(
        path: audio!.path,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
    } else {
      isInited = true;
      fileExist = false;
      downloadAudio();
    }
  }

  changeProgress(double value) {
    playerController.seekTo(value.toInt());
  }
}
