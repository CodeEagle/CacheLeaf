<center> ![Rem](./CacheLeaf.png)</center>

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
