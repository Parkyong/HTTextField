//
//  WKColor.swift
//  TYYCache
//
//  Created by Hunta_Developer on 2018/4/26.
//  Copyright © 2018年 Hunta. All rights reserved.
//

import UIKit

open class WKColor: NSObject {
   public static func kRGBColorFromHex(rgbValue: Int) -> (UIColor) {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: 1.0)
    }
}
