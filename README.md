# Food for all app
![travis build](https://img.shields.io/badge/platform-iOS-F16D39.svg?style=flat&color=green)
![travis build](https://img.shields.io/badge/Swift-5-F16D39.svg?style=flat) 
![travis build](https://img.shields.io/badge/version-1.0-F16D39.svg?style=flat&color=green)

![alt text](https://cdn4.vectorstock.com/i/1000x1000/31/73/fast-food-combo-icon-hamburge-pizza-drink-vector-21933173.jpg)

## Table of Contents
1. [About the Project](#About-the-project)
1. [Requirements](#Requirements)
1. [Project included features](#Project-included-features)
1. [Project flow description](#Project-flow-description)
1. [Support](#Support)
1. [Contributers](#Contributors)

# About the Project
   - (Food for all) project mainly is El-Menus task and its goal to show list of food tags and each tag contains its items.
 
# Requirements

- iOS 11.0 or later
- Xcode 11.0 or later
- Swift 5.0 or later

![](name-of-giphy.gif)


# Project included features
- Clean code with MVVM and protocols.
- Pagination
- Caching for offline mode.
- No storyboard 
- Testing
- CI/CD using fastlane
- Simple doucmentation and comments

# Project flow description:
1. In upper navigation bar use search button to convert between on fly searching (by changing characters in search bar) and manual search (when pressing search button in keyboard).. DEFAULT is on fly search.
1. You can pull to refresh so the app will fetch its intial reuests (Tags page = 1 and preselect first tag and show its items).
1. Theres's caching. If there's cached data get it else load request.
1. In case of error occurrence, An error view will appeare in top of the app for 3 seconds with error localized message and disappear after then.
1. In Item info screen, You can scroll up and down just in case description height > screen height.

# CI/CD integration:
1. setup fastlane <https://docs.fastlane.tools/getting-started/ios/setup/>
1. I've made a script to do these tasks to automatically make tests:

* To run the script just put this command in terminal :
   `sh Run_automated_tests.sh`
   
* This script includes :

        init fastlane
        export PATH="$HOME/.fastlane/bin:$PATH"  
        fastlane test
NOTE :
in case of this script doesn't work just run the above commands individually in terminal in project folder.

# Support 
Don't hesitate to reach me for any request or information  <michael.m.morkos@gmail.com>

# Contributors
- Michael Maher 


