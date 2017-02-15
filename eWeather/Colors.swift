//
//  Colors.swift
//  eWeather
//
//  Created by Thomas Kooi on 2/13/17.
//  Copyright © 2017 Thomas Kooi. All rights reserved.
//

import UIKit


extension UIColor {
    
    
    // MARK: Internal
    
    struct Temperatures {
        static var cold: UIColor { return UIColor(red: 224, green: 228, blue: 204) }
        static var chilly: UIColor { return UIColor(red: 167, green: 219, blue: 216) }
        static var cool: UIColor { return UIColor(red: 105, green: 210, blue: 231) }
        static var warm: UIColor { return UIColor(red: 243, green: 134, blue: 48) }
        static var hot: UIColor { return UIColor(red: 250, green: 105, blue: 0) }
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
