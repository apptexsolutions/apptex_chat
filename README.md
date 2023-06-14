 This package is a powerful and versatile solution for implementing real-time chat functionality in your Flutter applications. Built on Firebase Firestore and Firebase Cloud, this package provides a unique and pre-designed chatting system with features such as push notifications and a customizable theme for the Inbox Screen and Chat Screen.



## Platform Tested : Result OK

| Android | iOS | macOS | Web | Linux | Windows |
|---------|-----|-------|-----|-------|---------|
| ✔       | ✔   | :x:   | :x: |  :x:  |   :x:   |


## Key Features
* <b>Easy to use:</b> The package offers a straightforward implementation process, allowing you to integrate chat functionality seamlessly into your app.
* <b>Direct Integration:</b> Firebase Firestore and Firebase Cloud are directly integrated, ensuring reliable and efficient communication between users.
* <b>Pre-Build UI:</b> The package comes with a pre-built user interface for the chat screens, eliminating the need for extensive design work.
* <b>Start Chat with a Single Function:</b> Initiating a chat is as simple as calling a single function, enabling users to connect and communicate quickly.
* <b>Customizable Themes:</b> Both the Home Screen and Chat Screen can be customized to match your app's design and branding.


## Gallery
<div style="display:flex">
<code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Messages.png"></code>
<code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Chats.png"></code>
</div>

## Installation

To get started, add the following dependency to your pubspec.yaml file:

```yaml
dependencies:
  apptex_chat: ^2.0.0
```

Then, run `flutter pub get` to install the package.


## Usage

**Step 1 : Firebase Configuration**
 1. Install Firebase in your project
 2. Download google-services.json and GoogleService-Info.plist file for your project from firebase.
 3. Inilize firebase in the main function.

**Step 2 : User Authentication**

To enable chat functionality, you need to authenticate users. When a user signs up or logs in, you can pass their information to AppTexChat using the `initChat` method.
 ```dart
// Here you can set the current user to the Apptex chat
AppTexChat.instance.initChat(
  currentUser: ChatUserModel(
    uid: "{uid}",
    profileUrl: "{Profile url}",
    name: "{Currect User Name}",
    fcmToken: "{Fcm Token}", //Pass empty string if you don't have fcm token
  ),
);
```
Replace `Current User Name`, `uid`, `profile URL`, and `Fcm Token` with the corresponding values for the user.



**Step 3 : Starting a Chat**

To start a chat with another user, call the `startNewConversationWith` function:

 ```dart
 //Here you need to pass the other user's info
 AppTexChat.instance.startNewConversationWith(
   ChatUserModel(
     uid: "Other user uid",
     profileUrl: 'Other user profile',
     name: 'Other user name',
     fcmToken: 'Other user fcm token',
   ),
 );
```


## Show Conversations on Inbox Screen

To see a list of all the conversations, use the `ConversationsScreen` widget. It has a builder parameter which gives you the flexibility to list the conversation according to your app's design.
 ```dart
// Example 
ConversationsScreen(
   builder: (conversations, isLoading) => ListView.separated(
     separatorBuilder: (context, index) => SizedBox(height: 20),
     shrinkWrap: true,
     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
     itemCount: conversations.length,
     itemBuilder: (context, index) => Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10),
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             color: Colors.grey.withOpacity(0.5),
             spreadRadius: 1,
             blurRadius: 2,
             offset: Offset(0, 1),
           )
         ],
       ),
       padding: EdgeInsets.all(10),
       child: ListTile(
         onTap: () {
           //TODO: Navigate to chat screen
         },
         leading: CircleAvatar(
           backgroundImage:
               NetworkImage(conversations[index].otherUser.profileUrl ?? ''),
         ),
         title: Text(conversations[index].otherUser.name),
         subtitle: Text(conversations[index].lastMessage),
         trailing: Container(
           padding: EdgeInsets.all(5),
           decoration: BoxDecoration(
             color: Colors.blue,
             shape: BoxShape.circle,
           ),
           child: Text(
             conversations[index].unreadMessageCount.toString(),
             style: TextStyle(color: Colors.white),
           ),
         ),
       ),
     ),
   ),
 );
```


## Display messages of a specific chat

To see messages of a specific conversation, use the `ChatScreen` widget. It has an appBarBuilder(required) and 
bubbleBuilder(optional) parameter which gives you the flexibility to create custom appbar and chat bubbles according to your app's design.

 ```dart
ChatScreen(
  conversationModel: conversationModel, 
  showMicButton: false, //It is true by default, set it to false if you don't want voice messages
  appBarBuilder: ((currentUser, otherUser) => AppBar()), //Builder to create custom AppBar
);
```



## Features Status
1. Chating ✅ 
2. Voice messages ✅ 
3. Images ✅ 
4. Emojis ✅ 
5. Videos 🚫
6. Document 🚫
7. Location 🚫


## Additional information

More is about to Come:

**Features that will be added later:**
1. Push Notifications
2. Make it for web


## Frameworks Used
1. Firebase Firestore
2. Firebase Cloud storage


## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/XeroDays"><img src="https://avatars.githubusercontent.com/u/38852291?v=4" width="100px;" alt=""/><br /><sub><b>Sayed Muhammad Idrees</b></sub></a><br />
    <a href="https://github.com/XeroDays" title="Code">💻</a> <a href="https://github.com/XeroDays" title="Design">🎨</a></td>
    <td align="center"><a href="https://github.com/ShahSomething"><img src="https://avatars.githubusercontent.com/u/63047096?v=4" width="100px;" alt=""/><br /><sub><b>Shah Raza</b></sub></a><br /><a href="https://github.com/ShahSomething" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/mrcse"><img src="https://avatars.githubusercontent.com/u/73348512?v=4" width="100px;" alt=""/><br /><sub><b>Jamshid Ali</b></sub></a><br /><a href="https://github.com/mrcse" title="Code">💻</a></td>
  </tr>
</table>


## Help Maintenance


<a href="https://www.buymeacoffee.com/sayedidrees" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>
