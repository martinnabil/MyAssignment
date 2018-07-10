//
//  FontManager.swift
//  Careem​Assignment
//
//  Created by Martin Sorsok on 7/9/18.
//  Copyright © 2018 Martin Sorsok. All rights reserved.
//


import UIKit

class FontsManager: NSObject {
    
    static let shared = FontsManager()
    
    func OpenSansBoldWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
    func OpenSansLightWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Light", size: size)!
    }
    
    func OpenSansRegularWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: size)!
    }
    
    func OpenSansSemiBoldWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-SemiBold", size: size)!
    }
    
    func OpenSansExtraBoldWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-ExtraBold", size: size)!
    }
    
    func OpenSansItalicWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Italic", size: size)!
    }
    
    func RobotoSlabRegularWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Regular", size: size)!
    }
    
    func RobotoSlabLightWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Light", size: size)!
    }
    
    func RobotoSlabBoldWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoSlab-Bold", size: size)!
    }
    
}

