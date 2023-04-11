import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/conversation_model.dart';
import '../../models/message_model.dart';
import '../../myWidgets/image_bubble.dart';
import '../../myWidgets/message_bubble.dart';
import 'chat_view_model.dart';

class ChatScreen extends StatelessWidget {
  final ConversationModel conversationModel;
  final Color? backgroundColor;
  final Widget? emptyListMessage;
  final Widget? progressIndicator;
  final Widget Function(DateTime dateTime)? timeWidgetBuilder;
  final Widget typingWidget;

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
      required this.typingWidget,
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
            body: Stack(
              alignment: Alignment.center,
              children: [
                if (model.isChatReady) ...[
                  if (model.messages.isEmpty)
                    Center(
                        child: emptyListMessage ??
                            Text(
                              'No messages yet!',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ))
                  else
                    Positioned.fill(
                        child: ListView.builder(
                            itemCount: model.messages.length,
                            padding: EdgeInsets.only(top: 16, bottom: 62),
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
                                        messageModel.senderId ==
                                            model.currentUser.uid),
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
                                                      color:
                                                          Colors.grey.shade300,
                                                      blurRadius: 6,
                                                      offset:
                                                          const Offset(0, 2))
                                                ]),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                model.getMessageReferecneTime(
                                                    model.messages[index - 1]
                                                        .createdOn),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                ],
                              );
                            })),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: typingWidget,
                  ),
                  // Obx(() => Positioned(
                  //       bottom: chatController.replyMessage.value == null
                  //           ? 80
                  //           : 148,
                  //       right: 28,
                  //       child: scrol_button(),
                  //     )),
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
                          ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getCorrespondenseBubble(
      MessageModel messageModel, ChatViewModel model) {
    final isMine = messageModel.senderId == model.currentUser.uid;
    final code = messageModel.code;
    if (code == 'TXT')
      return MessageBubble(
          isMine: isMine,
          model: messageModel,
          currentUser: model.currentUser,
          otherUSer: model.otherUser);
    else if (code == 'IMG')
      return ImageBubble(
          isMine: isMine,
          model: messageModel,
          currentUser: model.currentUser,
          otherUSer: model.otherUser);
    else
      return Container();
  }
}
