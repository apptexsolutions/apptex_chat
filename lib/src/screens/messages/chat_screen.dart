import 'package:apptex_chat/src/widgets/audio_bubble.dart';
import 'package:apptex_chat/src/widgets/custom_animation.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../widgets/image_bubble.dart';
import '../../widgets/message_bubble.dart';
import 'chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  final ConversationModel conversationModel;
  final Color? backgroundColor;
  final Widget? emptyListMessage;
  final Widget? progressIndicator;
  final Widget Function(DateTime dateTime)? timeWidgetBuilder;
  final Widget? typingWidget;
  final bool showMicButton;

  ///It is a PreferredSizeWidget Function it should return PreferredSizeWidget like AppBar
  ///and this provide you two ChatuserModel parameters the first one is currentUser and the other is otherUser
  ///PreferredSizeWidget Function(ChatUserModel currentUser, ChatUserModel otherUser)
  final PreferredSizeWidget Function(
      ChatUserModel currentUser, ChatUserModel otherUser) appBarBuilder;

  ///Widget Function(MessageModel messageModel, ChatUserModel currentUser,
  ///ChatUserModel otherUser, bool isMine)
  final Widget Function(MessageModel messageModel, ChatUserModel currentUser,
      ChatUserModel otherUser, bool isMine)? bubbleBuilder;

  const ChatScreen(
      {Key? key,
      required this.conversationModel,
      required this.appBarBuilder,
      this.backgroundColor,
      this.emptyListMessage,
      this.progressIndicator,
      this.timeWidgetBuilder,
      this.typingWidget,
      this.showMicButton = true,
      this.bubbleBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(model: conversationModel),
      child: Consumer<ChatViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: appBarBuilder(model.currentUser, model.otherUser),
            backgroundColor: backgroundColor,
            bottomNavigationBar:
                typingWidget ?? defaultTypingArea(showMicButton),
            body: Stack(
              alignment: Alignment.center,
              children: [
                if (model.isChatReady) ...[
                  if (model.messages.isEmpty)
                    Center(
                      child: emptyListMessage ??
                          const Text(
                            'No messages yet!',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                    )
                  else
                    Positioned.fill(
                      child: ListView.builder(
                        itemCount: model.messages.length,
                        padding: const EdgeInsets.only(top: 16, bottom: 10),
                        reverse: true,
                        itemBuilder: (context, index) {
                          final messageModel = model.messages[index];
                          return Column(
                            children: [
                              if (bubbleBuilder == null)
                                getCorrespondenseBubble(messageModel, model)
                              else
                                bubbleBuilder!(
                                  messageModel,
                                  model.currentUser,
                                  model.otherUser,
                                  messageModel.isMine,
                                ),
                              if (index != 0 &&
                                  messageModel.createdOn.toDate().day !=
                                      model.messages[index - 1].createdOn
                                          .toDate()
                                          .day)
                                timeWidgetBuilder != null
                                    ? timeWidgetBuilder!((model
                                        .messages[index - 1].createdOn
                                        .toDate()))
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 4),
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2))
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            model.getMessageReferecneTime(model
                                                .messages[index - 1].createdOn),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                            ],
                          );
                        },
                      ),
                    ),
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   left: 0,
                  //   child: typingWidget ?? defaultTypingArea(),
                  // ),
                ] else
                  Center(
                    child: progressIndicator ??
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getCorrespondenseBubble(
      MessageModel messageModel, ChatViewModel model) {
    final code = messageModel.code;
    if (code == 'TXT') {
      return MessageBubble(
        model: messageModel,
      );
    } else if (code == 'IMG') {
      return ImageBubble(
        model: messageModel,
      );
    } else if (code == 'MP3') {
      return AudioBubble(
        model: messageModel,
      );
    } else {
      return Container();
    }
  }
}

Widget defaultTypingArea(bool showMicButton) {
  return Consumer<ChatViewModel>(
    builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //margin: EdgeInsets.only(bottom: 32, left: 32),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    if (model.micButtonPressed)
                      GestureDetector(
                        onTap: model.cancelVoiceMessage,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 27,
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.sentiment_satisfied_alt_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: model.micButtonPressed
                          ? AudioWaveforms(
                              recorderController: model.recorderController,
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.55, 40),
                              waveStyle: WaveStyle(
                                extendWaveform: true,
                                backgroundColor: Colors.black,
                                middleLineColor: Colors.transparent,
                                durationLinesColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : TextField(
                              controller: model.messageController,
                              maxLines: 4,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message",
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  model.showSendButton = true;
                                } else {
                                  model.showSendButton = false;
                                }
                                model.update();
                              },
                            ),
                    ),
                    const Icon(Icons.attach_file),
                    const SizedBox(width: 10),
                    const Icon(Icons.camera_alt),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Visibility(
              visible: model.showSendButton,
              child: InkWell(
                onTap: model.sendTextMessage,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
              replacement: !showMicButton
                  ? Container()
                  : model.micButtonPressed
                      ? GestureDetector(
                          onTap: model.sendVoiceMessage,
                          child: CustomAnimation(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onLongPress: model.startRecording,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                            ),
                          ),
                        ),
            ),
          ],
        ),
      );
    },
  );
}
