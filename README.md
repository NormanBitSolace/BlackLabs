# BlackLabs

A Swift Package containing Foundation, UIKit, and original type helpers and extensions.

***

* [Bundle](https://github.com/NormanBitSolace/BlackLabs/wiki/Bundle) - convenience helpers and extensions to access local files and common plist entries like app name and version.
* [CGContext](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/CGContext.swift) - convenience methods to draw lines and text in a CGContext.
* [CGGeometry](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/CGGeometery.swift) - convenience helpers for CGSize and CGRect and arrays containing those types.
* [CloudKit](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/CloudKit.swift) - convenience helpers and extensions for Apple's CloudKit API.
* [Collection](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Collection.swift)- convenience helpers and extensions for `Collection`.
* [Color](https://github.com/NormanBitSolace/BlackLabs/wiki/Color) - convert CSS color names and RGB hex values to UIColor. UIColor from hex 3, 4, 6, and 8 characters in length with or without # prefix. UIColor to hex. UIColor extension that creates immutable UIColor instances from hexadecimal and CSS color name strings (e.g. ff0, #f00, ff0000, ff0000ff, Pink, aZure, CLEAR, nil).
* [CommonColors](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/CommonColors.swift) - defines commonly used colors e.g. appWhite, appBlack, iOS7Blue, veryLightGray, evenColor, and oddColor.
* [Data](https://github.com/NormanBitSolace/BlackLabs/wiki/Data) - convenience helpers and extensions for `Data` handling, in particular when using REST.
* [Date](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Date.swift) - convenience helpers and extensions for working with `Date`s.
* [DeviceModels](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/DeviceModels.swift) - a list of Apple device models (e.g. iPhone1,1). This list is generated from the a well maintained gist by [Adam A Wolf](https://gist.github.com/adamawolf/3048717).
* [Encodable](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Encodable.swift) - convenience methods to encode a `Encodable` object and view it as a JSON string.
* [File](https://github.com/NormanBitSolace/BlackLabs/wiki/File) - Utilities for handling iOS document and app support as well as general encoding, decoding, data, etc. helpers.
* [Grid](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Grid.swift) - a generic class to handle 2D Arrays.
* [Holiday](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Holiday.swift) - convenience helpers and extensions for determine non fixed Holidays (e.g. 3rd Monday of February) based on `Date` and `Calendar`.
* [NetworkError](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/NetworkError.swift) - `enum` of network errors. `Result`s require an `Error` though in practice I don't bubble up these errors to the UI so this class is little used.
* [Notifications](https://github.com/NormanBitSolace/BlackLabs/wiki/Notifications) - prior to iOS 9 it was useful to use a token to ensure `NotificationCenter.removeObserver` was called, this class helps with that.
* [Number](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Number.swift) - convenience helpers and extensions for `Int`, `CGFloat`, and `Double` types e.g. formatting, conversion, and iterating.
* [Object](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Object.swift) - computed vars to access class name.
* [Queue](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Queue.swift) - A generic queue struct (thanks Ray Wenderlich algorithms).
* [RestHelper](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/RestHelper.swift) - a protocol and extensions to generalize REST CRUD. This protocol allows an app to use dependency injection of it's data services so testing can use different implementations.
* [RestPath](https://github.com/NormanBitSolace/BlackLabs/wiki/RestPath) - utilities for creating REST URL paths.
* [RestService](https://github.com/NormanBitSolace/BlackLabs/wiki/RestService) - A simple way to create a REST data service to handle failable CRUD operations (optionally in parallel).
* [Result](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Result.swift) - Extension to decode a `Result`s `Data` when successful with `let pet: Pet = result.decode()`.
* [Stack](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/Stack.swift) - A generic stack struct (thanks Ray Wenderlich algorithms).
* [String](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/String.swift) - `String` extensions e.g. `contains()`. Support for comma separated values.
* [UIDevice](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/UIDevice.swift) - defines `Screensize` struct, `ScreenType` enum. Extends `UIDevice` with modelName, isPad, isPhone, isSimulator, screenType, size, and landscapeSize properties.
* [UIView](https://github.com/NormanBitSolace/BlackLabs/wiki/UIView) - convenience helpers and extensions for `UIView`.
* [UIViewController](https://github.com/NormanBitSolace/BlackLabs/wiki/UIViewController) - convenience helpers and extensions for `UIViewController `.
* [UndoHistory](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/UndoHistory.swift) - a very simple way to implement undo in an app.
* [URL](https://github.com/NormanBitSolace/BlackLabs/wiki/URL) - `URL`s are extended to GET, POST, PUT, and DELETE. Helpers for getting `Codable`, `UIImage`, and `Data` in serial or parallel.
* [URLRequest & URLResponse](https://github.com/NormanBitSolace/BlackLabs/wiki/URLRequest-&-URLResponse) - Get method, url, status code, and header info.
* [URLSession](https://github.com/NormanBitSolace/BlackLabs/wiki/URLSession) - allows logging of information about network requests and responses.
* [UserDefaults](https://github.com/NormanBitSolace/BlackLabs/blob/master/Sources/BlackLabs/UserDefaults.swift) - utilities for using `UserDefaults` e.g. setting and getting `Codable` objects.
