//
//  UIButtonExtension.swift
//  ElTiempoApp
//
//  Created by Lina on 22/9/18.
//  Copyright © 2018 Daniel Cano. All rights reserved.
//

import UIKit

public extension UIButton {
    public func setGradientBackgroundColors(_ colors: [UIColor], direction: DTImageGradientDirection, for state: UIControlState) {
        if colors.count > 1 {
            // Gradient background
            setBackgroundImage(UIImage(size: CGSize(width: 1, height: 1), direction: direction, colors: colors), for: state)
        }
        else {
            if let color = colors.first {
                // Mono color background
                setBackgroundImage(UIImage(color: color, size: CGSize(width: 1, height: 1)), for: state)
            }
            else {
                // Default background color
                setBackgroundImage(nil, for: state)
            }
        }
    }
}
