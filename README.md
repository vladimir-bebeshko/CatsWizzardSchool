### CatsWizzardSchool

It's my pet project created while learning Combine, inspired by the Apple WWDC session.
I added couple of APIs from the https://rapidapi.com:
* one for [validating emails](https://rapidapi.com/themasterofweb/api/email-validator52)
* another for [getting cats images](https://rapidapi.com/rvaldezit/api/cat14/).

Keys and endpoints for them are stored in the `.env` file in the root of the project. This file is not committed to the VCS (you can get your own keys at RapidAPI, these APIs are free of charge).

Then `generate.sh` script is used to write the keys from `.env` to the `Credentials/APICreds.generated.swift`, using the Stencil template `APICreds.stencil`.

As about Combine itself, I tried and used the following features:
* URLSession's dataTaskPublisher
* map
* mapError
* decode
* receive(on:)
* eraseToAnyPublisher
* filter
* debounce
* removeDuplicates
* flatMap
* replaceError
* share
* combineLatest
* store(in:)
* Integration with SwiftUI
* TimerPublisher (refused to use here as it didn't suit the purpose)
* AnyCancellable
* Published
* ObservableObjerct
* assign
* sink
* adding custom operators to Publisher
* etc.

Additionally, I tried basic SwiftUI views:
* Text
* Button
* List
* etc.

Feel free to use it to your needs. Enjoy!