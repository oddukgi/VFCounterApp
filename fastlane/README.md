fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### build
```
fastlane build
```
Build the release app locally
### release
```
fastlane release
```
Update build + version number, commit changes and tag with version
### screenshots
```
fastlane screenshots
```
Make screenshots of app
### beta
```
fastlane beta
```
Build and upload the release app to TestFlight

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).