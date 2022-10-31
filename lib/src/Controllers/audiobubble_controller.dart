import 'dart:io';
import 'package:apptex_chat/src/Models/MessageModel.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'contants.dart';

class AudiobubbleController extends GetxController {
  String? name;
  MessageModel model;
  File? audio;
  RxBool isPlaying = false.obs;

  RxDouble max = 100.0.obs;
  RxDouble progress = 0.0.obs;
  static var httpClient = HttpClient();
  RxBool fileExist = false.obs;
  RxBool isDownloading = false.obs;
  RxBool isInited = false.obs;
  PlayerController playerController;

  AudiobubbleController(this.model, this.playerController) {
    name = FirebaseStorage.instance.refFromURL(model.message).name;
    isFileExist();

    playerController.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.initialized) {
        max.value = playerController.maxDuration.toDouble();
        if (max.value == -1) {
          max.value = 100;
        }
      }

      if (state == PlayerState.playing) {
        isPlaying.value = true;
      } else {
        isPlaying.value = false;
      }
    });

    playerController.onCurrentDurationChanged.listen((int duration) {
      progress.value = duration.toDouble();
    });
  }

  downloadAudio() async {
    isDownloading.value = true;

    await _downloadFile(model.message, name!);

    isDownloading.value = false;
    isFileExist();
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
    // playerController.stopAllPlayers();
    if (isPlaying.value) {
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
      fileExist.value = true;
      playerController.preparePlayer(audio!.path);
      playerController.setPlayerState(PlayerState.initialized);
      // playerController.startPlayer();
    } else {
      isInited.value = true;
      fileExist.value = false;
      downloadAudio();
    }
  }
}
