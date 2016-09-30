<center> ![Rem](./CacheLeaf.png)</center>
[![Build Status](https://travis-ci.org/CodeEagle/CacheLeaf.svg?branch=master)](https://travis-ci.org/CodeEagle/CacheLeaf)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/CodeEagle/CacheLeaf/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/CodeEagle/CacheLeaf.svg)](https://github.com/CodeEagle/CacheLeaf/releases)

<center>CacheLeaf</center>
---
iOS network middleware framework for handling request result cache, base on Alamofire

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
install
---
###Carthage
```
github "CodeEagle/CacheLeaf"
```
