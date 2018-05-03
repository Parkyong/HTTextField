//
//  ViewController.swift
//  HTTextField
//
//  Created by piaoyong.com@hotmail.com on 05/03/2018.
//  Copyright (c) 2018 piaoyong.com@hotmail.com. All rights reserved.
//

import UIKit
import HTTextField

class ViewController: UIViewController, WKTextFieldDelegate{
    
    let account: WKTextField = WKTextField(frame: CGRect(x: 10, y: 20, width: UIScreen.main.bounds.size.width-20, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(account)
        account.config = WKTextFieldConfig()
        account.delegate = self as WKTextFieldDelegate
        account.config.type = .kCodeVerify
        account.config.codeVerifyConfig.inputNum = 6
        account.codeTemplateLabel = BaseCodeLabel()
        account.errorFilter = {
            (text:String)->Bool in
            return true
        }
        account.updateViews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

