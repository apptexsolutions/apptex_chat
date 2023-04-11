// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';


// class RepliedToWidget extends StatelessWidget {
//   const RepliedToWidget(
//       {Key? key,
//       required this.showCloseButton,
//       required this.chatController,
//       required this.messageId,
//       required this.myID,
//       required this.title,
//       this.messegedByMe = true})
//       : super(key: key);

//   final bool showCloseButton;
//   final ChatController chatController;
//   final String messageId;
//   final String myID;
//   final String title;
//   final bool messegedByMe;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     MessageModel model = chatController.messages.firstWhere(
//         (element) => element.uid == messageId,
//         orElse: () => MessageModel());
//     final bool isMine = model.sendBy == myID;

//     return Container(
//       width: size.width,
//       height: showCloseButton ? 62 : null,
//       margin: showCloseButton
//           ? const EdgeInsets.only(top: 8.0)
//           : const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: showCloseButton ? Colors.white : Colors.black26.withOpacity(0.1),
//         borderRadius: showCloseButton
//             ? BorderRadius.circular(12)
//             : BorderRadius.circular(16),
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             Container(
//               width: 4,
//               margin: const EdgeInsets.only(top: 4.5, bottom: 4.5, left: 4),
//               decoration: BoxDecoration(
//                   color: showCloseButton || !messegedByMe
//                       ? kprimary1
//                       : Colors.white,
//                   borderRadius:
//                       const BorderRadius.horizontal(left: Radius.circular(16))),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding:
//                           const EdgeInsets.only(left: 16.0, right: 8, top: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             isMine ? 'You' : title,
//                             style: TextStyle(
//                                 color: showCloseButton || !messegedByMe
//                                     ? kprimary1
//                                     : Colors.white,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 13),
//                           ),
//                           Visibility(
//                             visible: showCloseButton && model.code == 'MSG',
//                             child: GestureDetector(
//                               onTap: () {
//                                 chatController.replyMessage.value = null;
//                               },
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.grey.shade300,
//                                 maxRadius: 12,
//                                 child: const Icon(
//                                   Icons.close_rounded,
//                                   size: 16,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 16.0, right: 16.0, bottom: 8.0),
//                       child: Text(
//                         model.code == 'MSG' ? model.message : 'Image',
//                         maxLines: showCloseButton ? 1 : 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                             color: showCloseButton
//                                 ? Colors.grey
//                                 : messegedByMe
//                                     ? Colors.grey.shade200
//                                     : Colors.black54,
//                             fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Visibility(
//               visible: model.code == 'IMG',
//               child: Stack(
//                 alignment: Alignment.topRight,
//                 children: [
//                   Container(
//                     width: 62,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: CachedNetworkImageProvider(model.message),
//                           fit: BoxFit.cover),
//                       color: isMine ? kprimary1 : kprimary2,
//                       borderRadius: BorderRadius.horizontal(
//                           right: showCloseButton
//                               ? const Radius.circular(12)
//                               : const Radius.circular(16)),
//                     ),
//                   ),
//                   Visibility(
//                     visible: showCloseButton,
//                     child: GestureDetector(
//                       onTap: () {
//                         chatController.replyMessage.value = null;
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: CircleAvatar(
//                           backgroundColor: Colors.grey.shade300,
//                           maxRadius: 10,
//                           child: const Icon(
//                             Icons.close_rounded,
//                             size: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }