// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The package description.
let package = Package(
    name: "AeroconfDemo",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other
        // packages.
        .library(
            name: "guunits",
            type: .dynamic,
            targets: ["CGUUnits"]
        ),
        .library(
            name: "GUUnits",
            targets: ["CGUUnits", "GUUnits"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/mipalgu/swiftfsm", from: "3.12.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package
        // depends on.
        .target(
            name: "CGUUnits",
            dependencies: []
        ),
        .target(name: "GUUnits", dependencies: ["CGUUnits"]),
        .testTarget(
            name: "CGUUnitsTests",
            dependencies: ["CGUUnits"]
        ),
        .testTarget(
            name: "GUUnitsTests", dependencies: ["CGUUnits", "GUUnits"]
        ),
        .testTarget(
            name: "FormalVerification",
            dependencies: [
                "CGUUnits",
                "GUUnits",
                .product(name: "swiftfsm", package: "swiftfsm"),
                .product(name: "FSMTest", package: "swiftfsm")
            ]
        )
    ]
)
