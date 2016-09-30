
import PackageDescription

let package = Package(
    name: "CacheLeaf",
    dependencies: [
        .Package(url: "https://github.com/Alamofire/Alamofire.git", versions: Version(4, 0, 1)..<Version(5, 0, 0))
    ]
)
