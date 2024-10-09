//
//  Placard+Layout.swift
//  Placard
//
//  Created by Christopher Charles Cavnor on 9/18/24.
//

import UIKit
import SwiftUI

extension Placard {

    /// Handles the layout of the Placard using auto-layout constraints from calculateConstraints.
    /// - Parameters:
    ///   - placement: placement of Placard view at top, middle, or bottom of screen.
    ///   - edgeInsets: UIEdgeInsets instance used to offset the Placard view vertically or restrict it horizontally.
    func layout(placement: PlacardPlacement, edgeInsets: UIEdgeInsets) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let parentView: UIView = self

        let backgroundView = UIView(frame: CGRect.zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        // position shadow based on placement
        switch placement {
        case .top:
            backgroundView.layer.shadowOffset = CGSizeMake(5, 5)
        case .center:
            backgroundView.layer.shadowOffset = CGSizeMake(0, 5)
        case .bottom:
            backgroundView.layer.shadowOffset = CGSizeMake(5, -5)
        }
        backgroundView.layer.shadowOpacity = 0.65
        backgroundView.layer.shadowRadius = 3
        backgroundView.layer.shadowColor = UIColor(red: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0).cgColor
        // rasterize for rendering efficiency
        backgroundView.layer.shouldRasterize = true
        backgroundView.layer.rasterizationScale = UIScreen.main.scale

        addSubview(backgroundView)

        guard let window = activeWindow else { return }

        switch placement {
        case .top:
            backgroundView.topAnchor.constraint(equalTo: window.topAnchor, constant: verticalConstraint!.constant).isActive = true
        case .bottom:
            backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: verticalConstraint!.constant).isActive = true
        case .center:
            backgroundView.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        }
        backgroundView.leftAnchor.constraint(equalTo: window.leftAnchor, constant: edgeInsets.left).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -edgeInsets.right).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true

        self.updateHeightConstraint()

        let customView = self.subviews[0]
        backgroundView.addSubview(customView)

        customView.leftAnchor.constraint(equalTo: parentView.leftAnchor,
                                         constant: edgeInsets.left).isActive = true
        customView.rightAnchor.constraint(equalTo: parentView.rightAnchor,
                                          constant: -edgeInsets.right).isActive = true

        // round corners
        customView.layer.cornerRadius = 5
        customView.clipsToBounds = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(Placard.deviceOrientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)

        self.layoutIfNeeded()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:))))
    }
}



