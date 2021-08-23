//  Created by Axel Ancona Esselmann on 12/28/20.
//  Copyright © 2020 eyaldar. All rights reserved.
//

import UIKit

extension UIView {
    func bounce() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")

        bounceAnimation.values = [0.05, 1.1, 0.9, 1]
        bounceAnimation.duration = 0.3

        var timingFunctions = [CAMediaTimingFunction]()

        for _ in 0..<4 {
            timingFunctions.append(CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut))
        }

        bounceAnimation.timingFunctions = timingFunctions
        bounceAnimation.isRemovedOnCompletion = false

        layer.add(bounceAnimation, forKey: "bounce")
    }
}
