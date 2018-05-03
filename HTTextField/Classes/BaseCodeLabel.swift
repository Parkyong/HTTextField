//
//  BaseCodeLabel.swift
//  TYYCache
//
//  Created by Hunta_Developer on 2018/4/27.
//  Copyright © 2018年 Hunta. All rights reserved.
//

import UIKit

open class BaseCodeLabel:UILabel{
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func createLabel()->UILabel{
        let label:BaseCodeLabel = BaseCodeLabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label;
    }
    
    open func setErrorColor(){

    }
    
    open func setNormalColor(){
    
    }
}
