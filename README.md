 This Package will give you a unique and pre-designed chatting system based on Firebase Firestore and Firebase Cloud.  It also has Push Notifications and a Custom Editable theme for both screens, such as Home Screen and Chat Screen.

Home Screen : 
It has all the Users which are recently contacted..

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


## Gallery
<div style="display:flex">
<code><img height="400px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Messages.png"></code>
<code><img height="400px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Chats.png"></code>
</div>



## Usage

**Step 1 : Firebase Configuration**
 1. Install Firebase in your project
 2. Download firebase.json and firebase.infoplist file for your project from firebase.
 3. Inilize firebase in the main function.

**Step 2 : Initialize AppTexChat**
 ```dart
// here the Full name os the current USer Full name
//and the uuid is the Firebase UID for that user.
AppTexChat.initializeUser(FullName: "Sayed Idrees", your_uuid: "sayeduuid");
```


**Step 3 : Start Chat with some user**

1. Just Call this function
2. Boom! That's it. Chat Started.


 ```dart
// Here you pass the BuildContext, and the reciever name and UUID
  AppTexChat.startChat(context,  receiver_name: "Shah Raza", receiver_id: "razauuid");
```


**Step 3 : Open HomeScreen**

1. To open all the connected chats just go to this chat screen.
2. Use this line
 ```dart
// Here you pass the BuildContext to open upa all chats.
  AppTexChat.OpenMessages(context);
```




## Features Status
1. Chating ✅ 
2. Voice recording ✅ 
3. Images ✅ 
4. Videos 🚫
5. Document 🚫
6. Location 🚫


## Additional information

More is about to Come:

**Features that will be added later:**
1. Voice Notes
2. Push Notifications
3. Make it for web


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
