# Remote Desktop Shutdown

Welcome to the **Remote Desktop Shutdown** Android app repository! This is a Flutter-based Android application that allows users to remotely shut down their PC or execute Windows Command Prompt (CMD) commands over a local network. (This will send a packet to all devieces in the same network so having more than 1 instance of the program will result in all devices getting shut down)

> ⚠️ Note: This repository contains only the source code for the Android application. The accompanying Windows application is hosted in a [**separate repository**](https://github.com/TBG101/Remote-Desktop-Shutdown-Windows).

## Features
* **Remote PC Shutdown:** Shutdown your PC with a single tap.
* **Execute CMD Commands:** Send commands directly to the Windows Command Prompt on your PC.
* **Local Network Operation:** Communication happens over your local network for fast interactions.
* **User-Friendly Interface:** Built with Flutter for a modern and intuitive design.

## Prerequisites
1. **PC-side Software:** Install the companion Windows application from the [**Windows Repository**](https://github.com/TBG101/Remote-Desktop-Shutdown-Windows).
   * This Windows application listens for requests from the Android app and executes the requested actions.
2. Both your Android device and PC must be connected to the same local network.
   
## Installation
### Android App
1. **Clone this repository:**
```bash
    Copy code
    git clone https://github.com/your-username/remote-pc-shutdown-android.git
    cd remote-pc-shutdown-android 
```
2. Open the project in your favorite Flutter IDE (e.g., Android Studio, Visual Studio Code).
3. Run the app on an Android device or emulator:
```bash
    Copy code
    flutter pub get
    flutter run
```

## Windows Companion App
* Visit the [**Windows Repository**](https://github.com/TBG101/Remote-Desktop-Shutdown-Windows) to download and set up the Windows application.

## Usage
1. **Setup the Windows App:** Run the Windows application and ensure it's ready to receive requests.
2. **Perform Actions:**
Use the app to send a shutdown request or execute commands on the PC.

## Built With
* **Flutter** - For building the Android app.
* **Dart** - Programming language for Flutter.
* **Windows API** - Used in the companion Windows application.

## Contributing
Contributions are welcome!

If you find bugs or have feature suggestions, feel free to open an issue or submit a pull request.

## Fork the repo.
1. **Create a feature branch:** git checkout -b feature/your-feature.
1. **Commit your changes:** git commit -m "Add your feature".
1. **Push to the branch:** git push origin feature/your-feature.
1. Open a pull request.

## Links
* [Windows Companion App Repository](https://github.com/TBG101/Remote-Desktop-Shutdown-Windows)

## Contact
For any questions or feedback, reach out at **ziedhrz@gmail.com**