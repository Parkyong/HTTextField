//
//  CustomCodeVerifyLabel.swift
//  TYYCache
//
//  Created by Hunta_Developer on 2018/5/2.
//  Copyright © 2018年 Hunta. All rights reserved.
//

import UIKit
import HTTextField

class CustomCodeVerifyLabel: BaseCodeLabel {
    let normalColor:CGColor = WKColor.kRGBColorFromHex(rgbValue: 0x999999).cgColor
    let errorColor:CGColor = WKColor.kRGBColorFromHex(rgbValue: 0xFE664F).cgColor
    let lineWidth:CGFloat = 5.0
    var tempColor:CGColor?
    
    public override init(frame: CGRect) {
        self.tempColor = normalColor
        super.init(frame: frame)
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createLabel() -> UILabel {
        let label:CustomCodeVerifyLabel = CustomCodeVerifyLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label;
    }
    
    override func setNormalColor() {
        self.tempColor = normalColor
        super.setNormalColor()
        self.setNeedsDisplay()
    }
    
    override func setErrorColor() {
        self.tempColor = errorColor
        super.setErrorColor()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext()else{
            return
        }
        
        let path =  CGMutablePath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addPath(path)
        
        context.setLineWidth(self.lineWidth)
        if let temp = self.tempColor{
            context.setStrokeColor(temp)
        }
        context.strokePath()
    }
    
}
