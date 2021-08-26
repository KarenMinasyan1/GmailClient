# Gmail Client
The app is designed to provide example of the basic workings of the Gmail Client Library.

## Installation instructons
In order to use the project, you will need to use CocoaPods to install dependencies.
For help with installing CocoaPods, see [their getting started guide](https://guides.cocoapods.org/using/getting-started.html#getting-started)

1. `sudo gem install cocoapods`

2. `cd <project directory>`

3. `pod install`. After Cocoapods has installed dependencies, open the project's .xcworkspace.

## Requirements to use
The app needs a ClientID, and redirectURI which you can obtain from the [Google Developer Console](https://console.developers.google.com/).

### To obtain an oAuth2 clientID and redirectURI:
1. Visit the [Google Developer Console](https://console.developers.google.com/)
2. Click Credentials on the left hand navigation panel.
3. Click the `Create Credentials Button` and select `oAuth Client id` from the resulting dropdown menu.
4. Select the `IOS` radio button.
5. Enter a memorable name for this key to help you identify it easily in the future.
6. Copy the Bundle Identifier from your IOS App.  This is found in your main project target under the `General` tab.
7. Click the `Create` Button and your are complete.

### After you have a new clientID and redirectURI.
1. Replace empty strings in GoogleAuthorizationService class.
2. Next, open the Info.plist and replace clientID for CFBundleURLTypes as well.

The app is ready to be run.
