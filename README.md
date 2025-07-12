# Flutter Chat App

A one-to-one chat application built with Flutter and Firebase.

## Features

*   Firebase Authentication for user login/registration.
*   Firestore for storing and retrieving real-time messages and user data.
*   Clean, modern UI using Material 3 design principles.
*   Light and Dark mode support.
*   Responsive layout for mobile, tablet, and web.
*   Unread message indicator on the user list.
*   One-to-one private messaging.

## Screenshots

<p align="center">
<img src="https://github.com/shahmoksh22/CHATAPPFLUTTER/tree/master/ScreenShot/1.png" alt="App Screenshot" width="200" height="400"/>

<img src="https://github.com/shahmoksh22/CHATAPPFLUTTER/tree/master/ScreenShot/2.png" alt="App Screenshot" width="200" height="400"/>

<img src="https://github.com/shahmoksh22/CHATAPPFLUTTER/tree/master/ScreenShot/3.png" alt="App Screenshot" width="200" height="400"/>

<img src="https://github.com/shahmoksh22/CHATAPPFLUTTER/tree/master/ScreenShot/4.png" alt="App Screenshot" width="200" height="400"/>

<img src="https://github.com/shahmoksh22/CHATAPPFLUTTER/tree/master/ScreenShot/5.png" alt="App Screenshot" width="200" height="400"/>

</p>

## Installation

1.  Create a Firebase project in the Firebase Console ([https://console.firebase.google.com/](https://console.firebase.google.com/)).
2.  Enable Authentication (Email/Password).
3.  Create a Firestore database.
4.  Clone the repository:

    ```bash
    git clone <repository_url>
    ```
5.  Configure FlutterFire:

    ```bash
    dart pub global activate flutterfire_cli
    flutterfire configure
    ```
6.  Run pub get:

    ```bash
    flutter pub get
    ```
7.  Run the app:

    ```bash
    flutter run
    ```

## Firebase Setup

Ensure you have the following Firebase services set up:

*   **Authentication:** Enabled with Email/Password sign-in method.
*   **Firestore:** Database created and security rules configured (remember to configure these properly before deploying to production).

## Contributing

Contributions are welcome! Please feel free to submit pull requests.
