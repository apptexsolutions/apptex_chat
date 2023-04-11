// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class SwipeToReply extends StatelessWidget {
//   final bool isMine;
//   final Widget child;
//   final DismissUpdateCallback callback;
//   const SwipeToReply(
//       {Key? key,
//       required this.isMine,
//       required this.child,
//       required this.callback})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: UniqueKey(),
//       movementDuration: const Duration(milliseconds: 100),
//       background: Align(
//         alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//         child: Padding(
//           padding: EdgeInsets.only(
//               right: isMine ? 8 : 0, left: isMine ? 0 : 8, top: 8.0),
//           child: Icon(
//             isMine
//                 ? CupertinoIcons.arrowshape_turn_up_right_fill
//                 : CupertinoIcons.arrowshape_turn_up_left_fill,
//             size: 20,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//       onUpdate: callback,
//       direction:
//           isMine ? DismissDirection.endToStart : DismissDirection.startToEnd,
//       dismissThresholds: const {
//         DismissDirection.endToStart: 1.0,
//         DismissDirection.startToEnd: 1.0
//       },
//       child: child,
//     );
//   }
// }