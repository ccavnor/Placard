//
//  Placard+DeviceOrientation.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 10/8/24.
//

import OSLog
import SwiftUI

public extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}

/*
 modified code from https://www.delasign.com/blog/swift-device-orientation/
 */
extension Placard {

    /// Get the current orientation of the device:
    ///
    ///     0 - UIDeviceOrientation.unknown
    ///     1- UIDeviceOrientation.portrait: Device oriented vertically, home button on the bottom
    ///     2 - UIDeviceOrientation.portraitUpsideDown: Device oriented vertically, home button on the top
    ///     3 - UIDeviceOrientation.landscapeLeft: Device oriented horizontally, home button on the right
    ///     4 - UIDeviceOrientation.landscapeRight: Device oriented horizontally, home button on the left
    ///     5 - UIDeviceOrientation.faceUp (ignored)
    ///     6 - UIDeviceOrientation.faceDown (ignored)
    ///
    /// - Returns: UIDeviceOrientation
    func getDeviceOrientation() -> UIDeviceOrientation {
        let identifier: String = Logger.subsystem
        var orientation = UIDevice.current.orientation

        if !orientation.isValidInterfaceOrientation {
            // Get the interface orientation incase the UIDevice Orientation doesn't exist.
            let interfaceOrientation: UIInterfaceOrientation?
            if #available(iOS 15, *) {
                interfaceOrientation = UIApplication.shared.connectedScenes
                // Keep only the first `UIWindowScene`
                    .first(where: { $0 is UIWindowScene })
                // Get its associated windows
                    .flatMap({ $0 as? UIWindowScene })?.interfaceOrientation
            } else {
                interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
            }
            guard interfaceOrientation != nil else {
                logger.error("\(identifier) UIApplication Orientation does not exist. This should never happen. Measured orientation \(interfaceOrientation.debugDescription)")
                return orientation
            }


            // Initially the orientation is unknown so we need to check based on the application window orientation.
            if !orientation.isValidInterfaceOrientation {
                logger.debug("\(identifier) Orientation is unknown.")
                logger.debug("\(identifier) Trying through the window orientation \(interfaceOrientation.debugDescription)")


                /*
                 Notice that UIDeviceOrientation.landscapeRight is assigned to UIInterfaceOrientation.landscapeLeft and   UIDeviceOrientation.landscapeLeft is assigned to UIInterfaceOrientation.landscapeRight. The reason for
                 this is that rotating the device requires rotating the content in the opposite direction.

                 Reference : https://developer.apple.com/documentation/uikit/uiinterfaceorientation
                 */
                switch interfaceOrientation {
                case .portrait: // portrait
                    logger.debug("\(identifier) Setting orientation to portrait.")
                    orientation = .portrait
                    break
                case .landscapeRight: // landscapeRight
                    logger.debug("\(identifier) Setting orientation to landscape left, as UIDeviceOrientation.landscapeRight is assigned to UIInterfaceOrientation.landscapeLeft.")
                    orientation = .landscapeLeft
                    break
                case .landscapeLeft: // landscapeLeft
                    logger.debug("\(identifier) Setting orientation to landscape right, as UIDeviceOrientation.landscapeLeft is assigned to UIInterfaceOrientation.landscapeRight.")
                    orientation = .landscapeRight
                    break
                case .portraitUpsideDown: // portraitUpsideDown
                    logger.debug("\(identifier) Setting orientation to portrait upside down.")
                    orientation = .portraitUpsideDown
                    break
                default:
                    logger.debug("\(identifier) Orientation is unknown.")
                    orientation = .unknown
                    break
                }
            }
        }

        return orientation
    }
}

