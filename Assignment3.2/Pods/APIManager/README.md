# api-manager

APIManager is a framework for abstracting RESTful API requests.


## Requirements

- iOS 10.0+ 
- Xcode 8.0+
- Swift 3.0+


## Installation


### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build APIManager.

To integrate APIManager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'APIManager', '~> 0.0.4'
end
```

Then, run the following command:

```bash
$ pod install
```


### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding APIManager as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/rauhul/api-manager.git", majorVersion: 0)
]
```


## Usage

APIManager relies on users to create `APIServices` relevent to the RESTful APIs they are working with.


### Making an APIService

An APIService is made up of 4 components.

1. A `baseURL`. Endpoints in this service will be postpended to this URL segment. As a result a baseURL will generally look like the root URL of the API the service communicates with.

```swift
open class var baseURL: String {
    return "https://api.example.com"
}
```

2. `HTTPHeaders` to be sent alongside the `APIRequest`s made by the endpoints in your `APIService`.

```swift
open class var headers: HTTPHeaders? {
    return [
        "Content-Type": "application/json"
    ]
}

```

3. A validation function `validate(json: JSON) -> JSONValidationResult`. This method provides a point outside of `APIRequest` for your service to validate the response json from a RESTful request. This validation should be common accross all endpoints in the service. If no validation is required, simply return `.success`.

```swift
open class func validate(json: JSON) -> JSONValidationResult {
    if let error = json["error"] as? String {
        return .failure(error: error)
    }   

    if json["data"] != nil {
        return .success
    }

    return .failure(error: "No data nor error returned.")
}
```

4. A set of RESTful api endpoints that you would like to use. These should be simple wrappers around the `APIRequest` constructor that can take in data (as `HTTPParameters` and/or `JSON`). For example if you would like to get some user information by id the endpoint may look like this:

```swift
open class func getUser(byId id: Int) -> APIRequest<GrootMerchService> {
    return APIRequest<ExampleService>(endpoint: "/users", params: ["id": id], body: nil, method: .GET)
}

```

> Please look at [acm-uiuc/groot-swift](https://github.com/acm-uiuc/groot-swift) for a more detailed example of an `APIService`


### Using an APIService

Now that you have an `APIService`, you can use it make RESTful API Requests. 

All the RESTful API endpoints we need to access should already be defined in our `APIService`, so using them is simply a matter of calling them.

Using the example service above, we can make a request to get the User associated with the id 452398:

```swift
let request = ExampleService.getUser(byId: 452398)
```

And subsecquently perform the `APIRequest` with:

```swift 
request.perform(withAuthorization: nil)
```

However, this leaves us unable to access the json response or error as well as requires multiple lines to do what is really one action. Conveniently `APIManager` allows us to solve this problems with simple chaining syntax. We can specify both success and failure blocks to be called with the response json (validated by our APIService) and error respectively. We can perform the request in the same statement as seen below:

```swift
ExampleService.getUser(byId: 452398)
.onSuccess { (json) in
    // Handle Success (Background thread)
    DispatchQueue.main.async {
        // Handle Success (main thread)
    }
}
.onFailure { (error) in
    // Handle Failure (Background thread)
    DispatchQueue.main.async {
        // Handle Failure (main thread)
    }
}
.perform(withAuthorization: nil)
```


## Support

Please [open an issue](https://github.com/rauhul/api-manager/issues/new) for support.


## Contributing

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/rauhul/api-manager/compare/).


## License

This project is licensed under the MIT License. For a full copy of this license take a look at the LICENSE file.
