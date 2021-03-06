import PackageDescription

let package = Package(
    name: "VaporDBAPNS",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/crypto.git", majorVersion: 2),
        .Package(url:"https://github.com/matthijs2704/vapor-apns.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/validation.git", majorVersion: 1)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
    ]
)

