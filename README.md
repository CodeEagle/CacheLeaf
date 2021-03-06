<p align="center">
<img src="./CacheLeaf.png" width=425/>
<br>
CacheLeaf
<br>
<pre align="center">iOS network middleware framework for handling request result cache, base on Alamofire</pre>
</p>

[![Swift](https://img.shields.io/badge/Swift-3.0-green.svg)](https://github.com/apple/swift) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/CodeEagle/CacheLeaf/master/LICENSE) [![Build Status](https://travis-ci.org/CodeEagle/CacheLeaf.svg?branch=master)](https://travis-ci.org/CodeEagle/CacheLeaf)
---

Requirements
---
iOS 9.0+ / macOS 10.11+

Xcode 8.0+

Swift 3.0+

Dependencies
---
[Alamofire 4.0.1+](https://github.com/Alamofire/Alamofire)

Installation
---
###Carthage
```
github "CodeEagle/CacheLeaf"
```

Usage
---
```swift
  import CacheLeaf
	...
    let url = URL(string: "https://httpbin.org/")!
    let req = URLRequest(url: url)
    req.execute(cache: 0, ignoreExpires: true, log: true, canCache: { _ in return true }) { (resp) in
                print("😆",resp.value)
                e.fulfill()
            }
    // or
    let url = URL(string: "https://httpbin.org/")!
    url.execute(cache: 0, ignoreExpires: true, log: true, canCache: { _ in return true }) { (resp) in
                print("😆",resp.value)
                e.fulfill()
            }
	...
```
Donations
---
<pre>
<p align="center">
<img src="./donate.jpg" width=320/>
</p>
</pre>
License
---
CacheLeaf is released under the MIT license. See LICENSE for details.
