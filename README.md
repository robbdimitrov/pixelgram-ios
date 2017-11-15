# PixelGram iOS Client

iOS client for the [PixelGram API](https://github.com/robbdimitrov/pixelgram-api).
It is written using the [MVVM](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
pattern and [RxSwift](https://github.com/ReactiveX/RxSwift).

## Setup

1. Clone and run the [API](https://github.com/robbdimitrov/pixelgram-api).
2. Clone the project and open in Xcode

```
$ git clone git@github.com:robbdimitrov/pixelgram-ios.git
$ cd pixelgram-ios
```

5. Install the [`CocoaPods`](https://cocoapods.org/) dependencies

```
$ pod install
```

4. Change the `baseURL` inside `APIClient` to point to your server.
5. Run the iOS client on a device or a simulator

## Contact

[Robert Dimitrov](http://robbdimitrov.com)
[@robbdimitrov](https://twitter.com/robbdimitrov)

## License

Copyright (c) 2017 Robert Dimitrov. Code released under the [MIT license](LICENSE).
