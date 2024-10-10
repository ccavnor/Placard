// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/*
 For building DocC static website (for Placard repository Github pages), using the procedure outlined here:

 https://www.createwithswift.com/publishing-docc-documention-as-a-static-website-on-github-pages/

 With the following process-archive command:

     $(xcrun --find docc) process-archive \
     transform-for-static-hosting ./Placard.doccarchive \
     --output-path ./docs \
     --hosting-base-path Placard
 */

let package = Package(
    name: "Placard",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Placard",
            targets: ["Placard"]),
    ],
    targets: [
        .target(
            name: "Placard"),
    ]
)
