<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

This Package will give you a unique and pre-designed chatting system based on Firebase Firestore and Firebase Cloud.  It also has Push Notifications and a Custom Editable theme for both screens, such as Home Screen and Chat Screen.

Home Screen : 
It has all the Users which are recently contacted. 

Chat Screen : 
Ofcourse, a chat screen to chat. No explaination needed but, Yes you can change colors and themes

## Features

1. Easy to use
2. Direct Integration
3. Firebase with only two listeners
4. Pre-Build UI
5. Start Chat with single function.
6. No Extra Database needed
7. Push Notifications
8. All Chatting Features

## Getting started

Okay so its not that complicated.
First you have to execute this line of code at the begining of the project where you get the user detials..
> You can place it on the Login page / Controller.



## Usage

**Step 1 : Initialize AppTexChat**
 ```dart
// here the Full name os the current USer Full name
//and the uuid is the Firebase UID for that user.
AppTexChat.initializeUser(FullName: "Jamshed Khan", your_uuid: myUUID);
```


**Step 2 : Start Chat with some user**

1. Just Call this function
2. Boom! That's it. Chat Started.


 ```dart
// Here you pass the BuildContext, and the reciever name and UUID
  AppTexChat.startChat(context,  receiver_name: "Sayed idrees", receiver_id: otherUser);
```


**Step 3 : Open HomeScreen**

1. To open all the connected chats just go to this chat screen.




## Additional information

More is about to Come:

**Features that will be added later:**
1. Voice Notes
2. Push Notifications
3. Make it for web


## Frameworks Used
1. Firebase Firestore
2. Firebase Cloud storage
