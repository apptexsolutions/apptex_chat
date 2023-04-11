import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/conversation_model.dart';
import 'conversation_view_model.dart';

class ConversationsScreen extends StatelessWidget {
  final Widget Function(List<ConversationModel> conversations, bool isLoading)
      builder;
  const ConversationsScreen({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConversationViewModel(),
      child: Consumer<ConversationViewModel>(
        builder: (context, model, child) =>
            builder(model.conversations, model.isLoading),
      ),
    );
  }
}
