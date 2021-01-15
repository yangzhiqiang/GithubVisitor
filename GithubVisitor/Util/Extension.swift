//
//  Extension.swift
//  GithubVisitor
//
//  Created by David Yang on 2021/1/15.
//

import UIKit

extension UIColor {
    static func fromRGBWithAlpha(_ rgbValue : UInt32,alpha : CGFloat) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0xFF)/255.0,
                       alpha: alpha);
    }
    
    static func fromRGB(_ rgbValue : UInt32) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0xFF)/255.0,
                       alpha: 1.0);
    }
}

extension UIScreen {
    static func currentWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    static func currentHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height;
    }
}
