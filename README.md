 This Package will give you a unique and pre-designed chatting system based on Firebase Firestore and Firebase Cloud.  It also has Push Notifications and a Custom Editable theme for both screens, such as Home Screen and Chat Screen.

Home Screen : 
It has all the Users which are recently contacted..

Chat Screen : 
Ofcourse, a chat screen to chat. No explaination needed but, Yes you can change colors and themes


## Platform Tested : Result OK

| Android | iOS | macOS | Web | Linux | Windows |
|---------|-----|-------|-----|-------|---------|
| ✔       | ✔   | :x:   |  ✔  | :x:   | :x:     |

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  apptex_chat: ^1.2.1
```

Then, run `flutter pub get` to install the package.



## Features

1. Easy to use
2. Direct Integration
3. Firebase with only two listeners
4. Pre-Build UI
5. Start Chat with single function.
6. No Extra Database needed
7. Push Notifications
8. All Chatting Features



## Gallery
<div style="display:flex">
<code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Messages.png"></code>
<code><img height="500px" src="https://raw.githubusercontent.com/XeroDays/apptex_chat/main/imgs/Chats.png"></code>
</div>



## Usage

**Step 1 : Firebase Configuration**
 1. Install Firebase in your project
 2. Download firebase.json and firebase.infoplist file for your project from firebase.
 3. Inilize firebase in the main function.

**Step 2 : Initialize AppTexChat**
 1. Call AppTexChat.init(); in main(); 
 For Example
 ```dart
//This is your main function
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  AppTexChat.init();
  runApp(const MyApp());
}
```


**Step 3 : Login your current User at Login State Changes**
1. When the Auth User is Signed-up or Logged in, Use it there.
For example
 ```dart
// Here you can set the current user to the Apptex chat, ProfileURl is Optional
    AppTexChat.instance.Login_My_User(
                      FullName: "{Currect User Name}",
                      your_uuid: "{uuid}",
                      profileUrl: "{profile url}");
```


**Step 4 : Start Chat with some user**

1. Just Call this function to start chat.
2. Ka-Bo0om! That's it. Chat Started.


 ```dart
// Here you pass the BuildContext, and the reciever name and UUID to which user you want to talk to.
   AppTexChat.instance.Start_Chat_With(context,
                    receiver_name: other.name,
                    receiver_id: other.uuid,
                    receiver_profileUrl: other.url);
```


**Step 5 : Open HomeScreen**

1. To open all chats connected to that specific user, just go to this chat screen.
2. Use this line
 ```dart
// Here you pass the BuildContext to open upa all chats.
  AppTexChat.instance.OpenMessages(context);
```


**Optional : Get AllChats Widget**

1. To get the Widget for all of the chats.
2. Use this line
 ```dart
// Here you pass the BuildContext to open upa all chats.
  AppTexChat.instance.GetMyMessages(context);
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
