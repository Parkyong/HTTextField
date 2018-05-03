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
    
    let code: WKTextField = WKTextField(frame: CGRect(x: 10, y: 20, width: UIScreen.main.bounds.size.width-20, height: 50))
    
    let phone: WKTextField = WKTextField(frame: CGRect(x: 10, y: 90, width: UIScreen.main.bounds.size.width-20, height: 50))

    let normal: WKTextField = WKTextField(frame: CGRect(x: 10, y: 180, width: UIScreen.main.bounds.size.width-20, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //验证码
        self.view.addSubview(code)
        code.config = WKTextFieldConfig()
        code.delegate = self as WKTextFieldDelegate
        code.config.type = .kCodeVerify
        code.config.codeVerifyConfig.inputNum = 6
        code.codeTemplateLabel = CustomCodeVerifyLabel()
        code.errorFilter = {
            (text:String)->Bool in
            return true
        }
        code.updateViews()
        
        //电话号码
        self.view.addSubview(phone)
        phone.config = WKTextFieldConfig()
        phone.textField.font = UIFont.systemFont(ofSize: 30)
        phone.delegate = self as WKTextFieldDelegate
        phone.config.type = .kPhone
        phone.errorFilter = {
            (text:String)->Bool in
            return true
        }
        
        //正常
        self.view.addSubview(normal)
        normal.config = WKTextFieldConfig()
        normal.delegate = self as WKTextFieldDelegate
        normal.config.type = .kNormal
        normal.errorFilter = {
            (text:String)->Bool in
            return true
        }

        let button:UIButton = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: 10, y: 250, width: UIScreen.main.bounds.size.width-20, height: 50)
        button.backgroundColor = .red
        button .addTarget(self, action: #selector(touchAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(button)

    }
    
    @objc func touchAction(){
        normal.textField.resignFirstResponder()
        phone.textField.resignFirstResponder()
        code.textField.resignFirstResponder()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

