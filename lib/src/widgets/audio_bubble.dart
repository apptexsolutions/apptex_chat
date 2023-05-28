import 'package:apptex_chat/src/core/services/audio_bubble_view_model.dart';
import 'package:apptex_chat/src/core/utils/utils.dart';
import 'package:apptex_chat/src/models/message_model.dart';
import 'package:apptex_chat/src/widgets/profile_picture.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioBubble extends StatelessWidget {
  final MessageModel model;
  const AudioBubble({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 16;
    Size size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          model.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!model.isMine) Container(width: 3),
        if (!model.isMine)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8, top: 6),
            child: ProfilePic(model.sender.profileUrl ?? ''),
          ),
        IntrinsicWidth(
          child: Container(
            constraints: BoxConstraints(
                minWidth: 50,
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: model.isMine
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                topLeft: model.isMine
                    ? Radius.circular(radius)
                    : Radius.circular(radius),
                bottomLeft: model.isMine
                    ? Radius.circular(radius)
                    : const Radius.circular(0),
                bottomRight: model.isMine
                    ? const Radius.circular(0)
                    : Radius.circular(radius),
                topRight: model.isMine
                    ? Radius.circular(radius)
                    : Radius.circular(radius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: ChangeNotifierProvider(
                      create: (context) => AudioBubbleViewModel(
                        model,
                        PlayerController(),
                      ),
                      child: Consumer<AudioBubbleViewModel>(
                          builder: (context, audiobubbleController, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 40,
                              child: !audiobubbleController.fileExist
                                  ? Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: audiobubbleController.isDownloading
                                          ? Container(
                                              height: 40,
                                              width: 40,
                                              padding: const EdgeInsets.all(10),
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                audiobubbleController
                                                    .downloadAudio();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: !audiobubbleController
                                                        .isInited
                                                    ? Icon(
                                                        Icons.play_arrow,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      )
                                                    : const Icon(
                                                        Icons.download),
                                              ),
                                            ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        audiobubbleController.playAudio();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          audiobubbleController.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                            ),
                            audiobubbleController.fileExist
                                ? SizedBox(
                                    width: size.width * 0.5,
                                    child: Slider(
                                      thumbColor: Colors.grey[200],
                                      activeColor: Colors.white,
                                      min: 0,
                                      inactiveColor: Colors.grey[400],
                                      max: audiobubbleController.max,
                                      value: audiobubbleController.progress,
                                      onChanged: (progress) {
                                        audiobubbleController
                                            .changeProgress(progress);
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    width: size.width * 0.5,
                                    child: Slider(
                                      thumbColor: Colors.grey[200],
                                      activeColor: Colors.white,
                                      min: 0,
                                      max: 100,
                                      value: 0,
                                      onChanged: (a) {},
                                    ),
                                  )
                          ],
                        );
                      }),
                    )),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 2),
                    child: Text(
                      getFormatedDayAndTime(model.createdOn),
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 10,
                        color: model.isMine
                            ? Colors.grey.shade200
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (model.isMine)
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 8, top: 6),
            child: ProfilePic(model.sender.profileUrl ?? ''),
          ),
      ],
    );
  }
}
