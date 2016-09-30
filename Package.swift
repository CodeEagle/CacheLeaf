
import PackageDescription

let package = Package(
    name: "CacheLeaf",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git",
                 majorVersion: 4.0.1)
    ]
)
