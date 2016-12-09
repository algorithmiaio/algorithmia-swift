#algorithmia
===================
A Swift/iOS client library for the Algorithmia API

Note: This client was written with Swift 3.0 (Xcode 8, iOS 10)

For API documentation, see the [SwiftDocs](https://algorithmia.com/docs/lang/swift)

[![CocoaPods](https://img.shields.io/cocoapods/v/Algorithmia.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/Algorithmia.svg)]()
[![](https://img.shields.io/badge/OS%20X-10.9%2B-lightgrey.svg)]()
[![](https://img.shields.io/badge/iOS-10.0%2B-lightgrey.svg)]()

# Getting started

## Installation

### CocoaPods

You can install via CocoaPods by adding it to your `Podfile`:

```ruby
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

pod 'algorithmia'
```

And run `pod install`.

### Manual

You can clone the repo and drag & copy files in Algorithmia

## API Key
Instantiate a client using your API Key:

```swift
let client = Algorithmia.client(simpleKey: apiKey)
```
Notes:
- API key may be omitted only when making calls from algorithms running on the Algorithmia cluster

## Calling Algorithms
The following examples of calling algorithms are organized by type of input/output which vary between algorithms.

Note: a single algorithm may have different input and output types, or accept multiple types of input,
so consult the algorithm's description for usage examples specific to that algorithm.

### Text input/output

Call an algorithm with text input by simply passing a string into its `pipe` method.
If the algorithm output is text, then call `getText` method to get result as string.

```swift
let foo = client.algo(algoUri: "algo://demo/Hello/0.1.1")
foo.pipe(text: "foo") { resp, error in
    if (error == nil) {
        let data = resp.getText()
        let metadata = resp.getMetadata()
    } else {
        print(error)
    }
}
```

### JSON input/output

Call an algorithm with JSON input by simply passing in a type that can be serialized to JSON:
most notably python dicts and arrays.
For algorithms that return JSON, call `getJson` method of the response to get the appropriate
deserialized type.

```swift
let foo = client.algo(algoUri: "algo://WebPredict/ListAnagrams/0.1.0")
foo.pipe(json: jsonData) { resp, error in
    if (error == nil) {
        let data = resp.getJSON()
        let metadata = resp.getMetadata()
    } else {
        print(error)
    }
}
```
If you already have serialzied JSON, you can call as follows:

```swift
let foo = client.algo("")
let jsonWords = "[\"transformer\", \"terraforms\", \"retransform\"]"
foo.pipe(rawJson: jsonWords) { resp, error in

}
```
### Binary input/output

Call an algorithm with Binary input by passing a Data Object into the `pipe` method.
Similarly, if the algorithm response is binary data, then result of `getData` method
will be a Data object from byte array.

```swift
let foo = client.algo(algoUri: "algo://WebPredict/ListAnagrams/0.1.0")
foo.pipe(data: data) { resp, error in
    if (error == nil) {
        let data = resp.getData()
        let metadata = resp.getMetadata()
    } else {
        print(error)
    }
}
```


### Error handling

API errors and Algorithm exceptions will return `AlgoError` in callback to `pipe` method:

```swift
let foo = client.algo(algoUri: "algo://util/whoopsWrongAlgo")
foo.pipe(text: "foo") { resp, error in
    if let error = error as? AlgoError {
        switch error {
        case .ProcessError:
            print("Algorithmia Error:",error)
            break;
        case .DataError:
            print("Data Error:",error)
            break;
        default:
            break;
        }
    }
}
// Algorithmia Error: algorithm algo://util/whoopsWrongAlgo not found
```


## Working with Data

The Algorithmia Java client also provides a way to manage both Algorithmia hosted data
and data from Dropbox or S3 accounts that you've connected to you Algorithmia account.

This client provides a `AlgoDataFile` type (generally created by `client.file(uri)`)
and a `AlgoDataDirectory` type (generally created by `client.dir(uri)`) that provide
methods for managing your data.

### Create directories

Create directories by instantiating a `AlgoDataDirectory` object and calling `create()`:

```swift
let robots = client.dir("data://.my/robots")
robots.create { error in
...
}

let dbxRobots = client.dir("dropbox://robots")
dbxRobots.create { error in
...
}
```

### Upload files to a directory

Upload files by calling `put` on a `AlgoDataFile` object, or by calling `putFile` on a `AlgoDataDirectory` object.

```swift
let robots = client.dir("data://.my/robots")

// Upload local file
robots.putFile(file:fileURL) { file, error in
...
}

// Write a text file
robots.file("Optimus_Prime.txt").put(string:"Leader of the Autobots") { error in
...
}
```

### Download contents of file

Download files by calling `getString`, `getData`, or `getFile` on a DataFile object:

```swift
let robots = client.dir("data://.my/robots")

// Download file and get the file handle
robots.file("T-800.png").getFile { url, error in
...
}

// Get the file's contents as a string
robots.file("T-800.txt").getString { text, error in
	...
}
// Get the file's contents as a byte array
robots.file("T-800.dat").getData(completion: { (text, error) in
	...
})
```

### Delete files and directories

Delete files and directories by calling `delete` on their respective `AlgoDataFile` or `AlgoDataDirectory` object.
`AlgoDataDirectory` take an optional `force` parameter that indicates whether the directory should be deleted
if it contains files or other directories.

```swift
client.file("data://.my/robots/C-3PO.txt").delete() { error in
...
}
client.dir("data://.my/robots").delete(force: false) { result, error in
...
}
```

### List directory contents

Iterate over the contents of a directory using the iterator returned by calling `files`, or `dirs` on a `DataDirectory` object:

```swift
// List top level directories
let myRoot = client.dir("data://.my")
myRoot.forEach(file: { file in
        ...
    }, completion: { error in
        ...
})

// List files in the 'robots' directory
myRoot.forEach(dir: { file in
        ...
    }, completion: { error in
        ...
})
```

### Manage directory permissions

Directory permissions may be set when creating a directory, or may be updated on already existing directories.

```swift
let fooLimited = client.dir("data://.my/fooLimited")

// Create the directory as private
fooLimited.create(readACL:.PRIVATE) { error in
	...
}

// Update a directory to be public
fooLimited.update(readACL:.PUBLIC) { error in
	...
}
```
