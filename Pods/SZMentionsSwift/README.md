[![codecov](https://codecov.io/gh/szweier/SZMentionsSwift/branch/master/graph/badge.svg)](https://codecov.io/gh/szweier/SZMentionsSwift)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/szweier)
[![Build Status](https://travis-ci.org/szweier/SZMentionsSwift.svg?branch=master)](https://travis-ci.org/szweier/SZMentionsSwift)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SZMentionsSwift.svg)](https://img.shields.io/cocoapods/v/SZMentionsSwift.svg)
[![Platform](https://img.shields.io/cocoapods/p/SZMentionsSwift.svg?style=flat)](http://cocoadocs.org/docsets/SZMentionsSwift)
[![Twitter](https://img.shields.io/badge/twitter-@StevenZweier-blue.svg?style=flat)](http://twitter.com/StevenZweier)

SZMentionsSwift is a lightweight mentions library for iOS. This library was built to assist with the adding, removing and editing of a mention within a textview.

## How To Get Started

- [Download SZMentionsSwift](https://github.com/stevenzweier/SZMentionsSwift/archive/master.zip) and try out the iOS example app. 

## Communication

- If you **need help**, feel free to tweet @StevenZweier
- If you **found a bug**, **have a feature request**, or **have a general question** open an issue.
- If you **want to contribute**, submit a pull request.

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) 

#### Podfile

To integrate SZMentionsSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SZMentionsSwift'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

Below is a quick run through of the objects used in this library but as always the best place to get an understanding of the current implementation of the SZMentionsSwift library is in the example code.

#### SZMentionsSwiftListener

This class manages the mention interaction.

##### Setup
Use one of the many initializers to setup your mentions listener.  Parameters explained below:

`mentionsTextView` : **required** The text view we are applying the mentions listener to. Note: it's delegate **must** be the mentions manager.

`mentionsManager` : **required** The class that will be handling the mention interaction.

`textViewDelegate` : **optional** If you would like to receive UITextView delegate methods set this and it will be passed through after processing view the mentions listener.

`mentionTextAttributes` : Attributes (see: `AttributeContainer`) to apply to the textview for all mentions

`defaultTextAttributes` : Attributes (see: `AttributeContainer`) to apply to the textview for all text that is not a mention.

`spaceAfterMention` : **optional** Whether or not you would like a space to be added to the end of your mentions. Default is `NO`

`trigger` : The string used to start a mention. Default is `@`

`cooldownInterval` : **optional** The amount of time to wait between calling showMentionsList. Default is `0.5`

`searchSpaces` : **optional** Mention searches can / cannot contain spaces

##### Properties

`mentions` : **readonly** Array of all mentions currently applied to the text view.

##### Methods

`@discardableResult public func addMention(_ mention: CreateMention) -> Bool` : Call this method while adding a mention to apply the mention to the current text.

`public func insertExistingMentions(_ existingMentions: [CreateMention])`: Insert mentions into an existing textview.  This is provided assuming you are given text
along with a list of users mentioned in that text and want to prep the textview in advance.

#### CreateMention (Protocol)

This protocol contains the required properties for a mention being sent to the mentions listener

#### MentionsManagerDelegate (Protocol)

The required methods for handling mention interaction.

`func showMentionsListWithString(mentionsString: String)` lets the delegate know to show a mentions list as well as provides the current string typed into the textview, allowing for filtering of the mentions list.
`func hideMentionsList()` lets the delegate know we are no longer typing in a mention.
`func didHandleMentionOnReturn() -> Bool` allows you to handle when the user taps the enter key while searching for a mention. Return true if you've handled the interaction, false if you'd like to allow the listener to handle this event.

#### SZMention

This class is returned via the `mentions` method, it includes the `range` of the mention as well as `object` containing the object sent to the mentions listener via the `addMention(_ mention: CreateMention)` method.
    

## Unit Tests

SZMentionsSwift includes unit tests which can be run on the SZMentionsSwift framework.

## Credits

SZMentionsSwift was originally created by [Steven Zweier](http://twitter.com/StevenZweier)


